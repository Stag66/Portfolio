/* Project3.java  InsertInOrder with bSearch optimization to compute insertion index */
// STUDENT STARTER FILE
// YOUR NAME/ID:


import java.util.*;
import java.io.*;

public class Project3
{
	static final int INITIAL_CAPACITY = 5;

	public static void main( String args[] ) throws Exception
	{
		if (args.length < 1 )
		{
			System.out.println("ERROR: Must enter an int on cmd line (i.e. # of random ints to put in array)\n");
			System.exit(0);
		}

		int numInts2generate = Integer.parseInt( args[0] );

		// WE USE Random number generator to fill our array

		Random randGen =  new Random( 17 ); // SEED with 17
		int[] arr = new int[INITIAL_CAPACITY];
		int count= 0;
		for ( int i = 0 ; i<numInts2generate ; ++i)
		{
			if ( count==arr.length ) arr = upSizeArr(arr);
			insertInOrder( arr, count++, 1 + randGen.nextInt(1000) );
		}

		arr=trimArr(arr,count); // Now count == .length
		printArray( arr );  // we trimmed it thus count == length so we don't bother to pass in count

	} // END MAIN

	// ############################################################################################################

	static void printArray( int[] arr  )
    {
        for( int i=0 ; i<arr.length ;++i )
            System.out.print(arr[i] + " " );
        System.out.println();
    }

	static int[] upSizeArr( int[] fullArr )
	{
		int[] upSizedArr = new int[ fullArr.length * 2 ];
		for ( int i=0; i<fullArr.length ; ++i )
			upSizedArr[i] = fullArr[i];
		return upSizedArr;
	}

	static int[] trimArr( int[] oldArr, int count )
	{
		int[] trimmedArr = new int[ count ];
		for ( int i=0; i<count ; ++i )
			trimmedArr[i] = oldArr[i];
		return trimmedArr;
	}

	// REMOVE ALL COMMENTS FROM INSERT IN ORDER JUST BEFORE HANDIN
	static void insertInOrder( int[] arr, int count, int newVal   )
	{

		// WAIT TILL YUR PROGRAM PRODUCES PRODUCES CORRECT OUTPUT.
		// THEN REPLACE THE LINE BELOW WITH A CALL TO -YOUR- BSEARCH
		int index = bSearch( arr, count, newVal );
		
                        if ( index < 0 )
						{							
							index = -(index+1);
						}							// flip it back to +

                        for ( int i=count-1 ; i>= index ; --i )
						{
                            arr[i+1] = arr[i];
						}

                        
						arr[index] = newVal; // LEAVE THIS HERE. DO NOT REMOVE
	}

	// REMOVE ALL COMMENTS FROM BSEARCH JUST BEFORE HANDIN
	static int bSearch(int[] a, int count, int key)
	{
		int lo=0, hi=count-1;
        while ( lo <= hi )
        {
				int mid = lo + (hi-lo)/2;
				if ( key == a[mid] )
				{
					return mid;
				}
			
			if ( key > a[mid] )
			{
				lo = mid + 1;
			}
			else
			{
				hi = mid - 1;
			}
		}
    
		return -(lo + 1);  // it always belongs at LO

	}
} // END PROJECT3