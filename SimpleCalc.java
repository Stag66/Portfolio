// Demonstrates JPanel, GridLayout and a few additional useful graphical features.
// adapted from an example by john ramirez (cs prof univ pgh)
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.util.*;
import java.io.*;


public class SimpleCalc
{
	JFrame window;  // the main window which contains everything
	Container content;
	JButton[] digits = new JButton[12];
	JButton[] ops = new JButton[4];
	JTextField expression;
	JButton equals;
	JTextField result;
	String[] opCodes = { "+", "-", "*", "/" };
	int results;

	public static void main(String [] args)
	{
		new SimpleCalc();
	}
	public SimpleCalc()
	{
		window = new JFrame( "Simple Calc");
		content = window.getContentPane();
		content.setLayout(new GridLayout(2,1)); // 2 row, 1 col
		ButtonListener listener = new ButtonListener();

		JPanel topPanel = new JPanel();
		topPanel.setLayout(new GridLayout(1,3)); // 1 row, 3 col

		expression = new JTextField();
		expression.setFont(new Font("verdana", Font.BOLD, 16));
		expression.setText("");

		equals = new JButton("=");
		equals.setFont(new Font("verdana", Font.BOLD, 20 ));
		equals.addActionListener( listener );

		result = new JTextField();
		result.setFont(new Font("verdana", Font.BOLD, 16));
		result.setText("");

		topPanel.add(expression);
		topPanel.add(equals);
		topPanel.add(result);

		// bottom panel holds the digit buttons in the left sub panel and the operators in the right sub panel
		JPanel bottomPanel = new JPanel();
		bottomPanel.setLayout(new GridLayout(1,2)); // 1 row, 2 col

		JPanel  digitsPanel = new JPanel();
		digitsPanel.setLayout(new GridLayout(4,3));

		for (int i=0 ; i<10 ; i++ )
		{
			digits[i] = new JButton( ""+i );
			digitsPanel.add( digits[i] );
			digits[i].addActionListener( listener );
		}
		digits[10] = new JButton( "C" );
		digitsPanel.add( digits[10] );
		digits[10].addActionListener( listener );

		digits[11] = new JButton( "CE" );
		digitsPanel.add( digits[11] );
		digits[11].addActionListener( listener );

		JPanel opsPanel = new JPanel();
		opsPanel.setLayout(new GridLayout(4,1));

		for (int i=0 ; i<4 ; i++ )
		{
			ops[i] = new JButton( opCodes[i] );
			opsPanel.add( ops[i] );
			ops[i].addActionListener( listener );
		}
		bottomPanel.add( digitsPanel );
		bottomPanel.add( opsPanel );

		content.add( topPanel );
		content.add( bottomPanel );

		window.setSize( 640,480);
		window.setVisible( true );
	}

	// We are again using an inner class here so that we can access
	// components from within the listener.  Note the different ways
	// of getting the int counts into the String of the label

	class ButtonListener implements ActionListener
	{
		public void actionPerformed(ActionEvent e)
		{
			Component whichButton = (Component) e.getSource();
			for (int i=0 ; i<10 ; i++ )
				if (whichButton == digits[i])
					expression.setText( expression.getText() + i );

				if (whichButton == digits[10]) // C
				{	
					expression.setText("");
					result.setText("");
				}

				if (whichButton == digits[11]) // CE
				{
					if (expression.getText().length() == 0) return; // DO nothing
					int length = expression.getText().length();
					expression.setText( expression.getText().substring( 0, length-1 ) );
				}

				for ( int i=0 ; i< opCodes.length ; ++i )  //
					if(whichButton == ops[i])
					expression.setText( expression.getText() + opCodes[i] );
				
				if( whichButton == equals)
					result.setText( evaluation(expression.getText()));

		} // END Of ACTION PERFORMED
	} // ENd LISTENR CLASS



	public String evaluation (String expr)
	{
		for(int i=0; i < expr.length(); i++)
		{
			if ("01234567890+-*/.".indexOf(expr.charAt(i)) == -1 )
				return "INVALID EXPRESSION";
		}
		
		ArrayList<String> operatorList = new ArrayList<String>();
		ArrayList<Double> operandList = new ArrayList<Double>();
		StringTokenizer st = new StringTokenizer( expr,"+-*/", true );
		
		while (st.hasMoreTokens())
		{	String token = st.nextToken();
			if ("+-/*".contains(token))
				operatorList.add(token);
			else
				operandList.add( Double.parseDouble(token) );
    		}
		if(operatorList.size() != operandList.size()-1)  return "INVALID EXPRESSION";	

		for(int i=0; i<operatorList.size() ; i++)
		{	
			if(operatorList.get(i).equals("*"))
			{	operandList.set(i,operandList.get(i) * operandList.get(i+1));
				operandList.remove(i+1); 
				operatorList.remove(i);
				--i;
			}
			else if(operatorList.get(i).equals("/"))
			{	operandList.set(i,operandList.get(i)/operandList.get(i+1));
				operandList.remove(i+1); 
				operatorList.remove(i); 
				--i;
			}
		}

		for(int i=0;i<operatorList.size();i++)
		{	if(operatorList.get(i).equals("+"))
			{	operandList.set(i,operandList.get(i)+operandList.get(i+1));
				operandList.remove(i+1);
				operatorList.remove(i);
				i--;
			}
			else if(operatorList.get(i).equals("-"))
			{	operandList.set(i,operandList.get(i)-operandList.get(i+1));
				operandList.remove(i+1);
				operatorList.remove(i);
				i--;
			}
		}			
		if (operatorList.size() != 0 || operandList.size() != 1 ) return "INVALID EXPRESSION";
		
		// operandList.get(0) contains the final double result value return it as a String;
		return "" + operandList.get(0);	

	}
}
