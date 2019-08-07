import java.util.function.*;

public class BST<E extends Comparable<E>> {
	// not using a static class, as that will require us to
	// parameterize Node, which adds a bunch of code repetition.
	// and I HATE code repetition.
	private class Node {
		E value;
		Node left;
		Node right;

		Node(E value) {
			this.value = value;
		}
	}

	private Node _root = null;
	private int _size = 0;

	public BST() {
	}

	// Adds an item, returning true if it was successful or false if it already exists.
	public boolean add(E newEntry) throws NullPointerException {
		if(newEntry == null) {
			throw new NullPointerException("null newEntry");
		}

		if(_root == null) {
			_root = new Node(newEntry);
			_size++;
			return true;
		} else {
			return addImpl(_root, newEntry);
		}
	}

	// Removes an item, returning true if it was successful or false if it doesn't exist.
	public boolean remove(E anEntry) throws NullPointerException {
		if(anEntry == null) {
			throw new NullPointerException("null anEntry");
		}

		if(_root == null) {
			return false;
		} else {
			return removeImpl(_root, null, anEntry);
		}
	}

	// Returns whether or not the item exists.
	public boolean contains(E anEntry) throws NullPointerException {
		if(anEntry == null) {
			throw new NullPointerException("null anEntry");
		}

		// let's do this one iteratively.
		for(Node n = _root; n != null; ) {
			int compare = n.value.compareTo(anEntry);

			if(compare == 0) {
				return true; // found it!
			} else if(compare < 0) {
				// this value is less than what we're looking for; look to the right.
				n = n.right;
			} else {
				// this value is greater than what we're looking for; look to the left.
				n = n.left;
			}
		}

		// we hit a dead end, so it can't be in the tree.
		return false;
	}

	// Duh.
	public int size() {
		return _size;
	}

	// Duh.
	public boolean isEmpty() {
		return _size == 0;
	}

	// Print the values on one line in ascending order.
	public void printInorder() {
		// Eating our own dogfood... ;)
		visitInorderImpl(_root, (v) -> System.out.print(v + " "));
		System.out.println();
	}

	// Allows the user to iterate over the items in order without using
	// a big dumb Iterator object.
	public void visitInorder(Consumer<E> callback) {
		visitInorderImpl(_root, callback);
	}

	public void printPreorder() {
		printPreorderImpl(_root, 0);
	}

	////////////////////////////////////////////////////////////////////////////////////////////////

	// See how much simpler this is than implementing an Iterator?
	private void visitInorderImpl(Node n, Consumer<E> callback) {
		if(n != null) {
			visitInorderImpl(n.left, callback);
			// writing a visitPreorderImpl or visitPostorderImpl would
			// be just as easy.
			callback.accept(n.value);
			visitInorderImpl(n.right, callback);
		}
	}

	// This is a common technique: pass a "depth" parameter which indicates
	// how far we are from the root. Each recursive call increases depth
	// by 1.
	private void printPreorderImpl(Node n, int depth) {
		if(n != null) {
			for(int i = 0; i < depth; i++) {
				System.out.print("| ");
			}

			System.out.println(n.value);
			printPreorderImpl(n.left, depth + 1);
			printPreorderImpl(n.right, depth + 1);
		}
	}

	// Recursive add function.
	boolean addImpl(Node n, E newEntry) {
		int compare = n.value.compareTo(newEntry);

		if(compare == 0) {
			return false; // already in the BST.
		} else if(compare < 0) {
			// this value is less than new value; try to put it to the right.

			if(n.right == null) {
				n.right = new Node(newEntry);
				_size++;
				return true;
			} else {
				return addImpl(n.right, newEntry);
			}
		} else {
			// this value is greater than new value; try to put it to the left.

			if(n.left == null) {
				n.left = new Node(newEntry);
				_size++;
				return true;
			} else {
				return addImpl(n.left, newEntry);
			}
		}
	}

	// Recursive remove function.
	boolean removeImpl(Node n, Node parent, E anEntry) {
		if(n == null) {
			return false; // dead end.
		}

		int compare = n.value.compareTo(anEntry);

		if(compare == 0) {
			// found it!

			if(parent == null) {
				// this is the root.
				_root = removeNode(_root);
			} else if(n == parent.left) {
				// we're the left child; remove me from the parent.
				parent.left = removeNode(n);
			} else {
				parent.right = removeNode(n);
			}

			_size--;
			return true;
		} else if(compare < 0) {
			// this value is less than new value; must be on the right.
			return removeImpl(n.right, n, anEntry);
		} else {
			// this value is less than new value; must be on the left.
			return removeImpl(n.left, n, anEntry);
		}
	}

	// Handles the ugly nitty gritty of removing a node.
	// Given a node n, returns the node that should replace n.
	// (That might be n itself, if it shouldn't be replaced.)
	private Node removeNode(Node n) {
		if(n.left == null) {
			if(n.right == null) {
				return null; // no children; replace me with null.
			} else {
				return n.right; // left == null, right != null; replace me with the right tree.
			}
		} else if(n.right == null) {
			return n.left; // left != null, right == null; replace me with the left tree.
		} else {
			// two children, hardest case.
			// let's use the "inorder predecessor" convention.

			Node parent = n;
			Node toRemove = n.left;

			// special case: the left child IS the biggest value.
			// in this case, either the left child is a leaf or or a 1-child node.
			// in both cases, we make this node point at its left.
			if(toRemove.right == null) {
				n.left = toRemove.left;
			} else {
				// 1. find the first node in the left subtree that has no right child.
				while(toRemove.right != null) {
					parent = toRemove;
					toRemove = toRemove.right;
				}

				// 2. either it's a leaf node, or it only has a left node.
				// in both cases, we make the parent's right point at its left.
				parent.right = toRemove.left;
			}

			// 3. no matter what, we copy the removed node's value into this node.
			n.value = toRemove.value;

			// we only changed this node's value; don't remove it from its parent!
			return n;
		}
	}
}