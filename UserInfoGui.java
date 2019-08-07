/*	JFrame3.java	EVENT DRIVEN PROGRAMMING USING JBUTTON, JTEXTFIELD AND ACTIONLISTENER INTERFACE
	(adapted from a John Ramirez example)
	
	WE INTRODUCE ANOTHER ACTIVE CONTROL, JTEXTFIELD WHICH ALLOWS ENTERY OF TEXT DATA. YOU HAVE SEEN
	THIS CONTROL ON WEB FORMS MANY TIMES TO ENTER PASSWORDS, EMAIL ADDRESSES AND SUCH. 
	
	WE DEFINE OUR CONTROLS AT THE TOP AS MEMBERS OF THE CLASS SO THAT IN OUR ACTIONLISTENER WE CAN
	COMPARE THE INCOMING OBJECT REF TO SEE WHICH OBJECT WAS CLICKED OR 'EVENTED'
	
	WE ALSO INTRODUCE AN INNER CLASS TO IMPLEMENT THE ACTION LISTENER. WE DO THIS BECUASE WE WANT 
	THE CODE INSIDE OUR LISTENER TO HAVE DIRECT ACCESS TO THE REF VARIABLES OF THE JBUTTON AND 
	TEXTFIELD CONTROLS.
*/

import java.awt.*;
import javax.swing.*;
import java.awt.event.*;

public class JFrame3{

	JFrame window;
	JTextField firstName,lastName,email,allInfo;
	JButton showInfoButton,resetInfoButton;
	
	Container content;

	// THIS IS THE CONSTRUCTOR OF OUR JFRAME3 CLASS. IT IS CALLED BY MAIN
	public JFrame3()
	{
		window= new JFrame("JFrame 3");
		Listener listener = new Listener(); // CREATE AN INSTANCE OF OUR LISTENER CLASS
		
		showInfoButton = new JButton("CLICK TO DISPLAY ALL INFO");
		showInfoButton.setFont(new Font("Serif", Font.ITALIC + Font.BOLD, 20));
		showInfoButton.addActionListener(listener);
		
		resetInfoButton = new JButton("CLICK TO RESET ALL INFO FIELDS");
		resetInfoButton.setFont(new Font("Serif", Font.ITALIC + Font.BOLD, 20));
		resetInfoButton.addActionListener(listener);

		firstName = new JTextField("replace with your first name");
		firstName.setFont(new Font("Serif", Font.ITALIC + Font.BOLD, 20));

		lastName = new JTextField("replace with your last name");
		lastName.setFont(new Font("Serif", Font.ITALIC + Font.BOLD, 20));
		
		email = new JTextField("replace with your email addy");
		email.setFont(new Font("Serif", Font.ITALIC + Font.BOLD, 20));

		allInfo = new JTextField("ALL INFO DISPLAYED HERE");
		allInfo.setFont(new Font("Serif", Font.ITALIC + Font.BOLD, 20));
		

		Container content= window.getContentPane();
		content.setLayout(new GridLayout(3,2));
		content.add(resetInfoButton);
		content.add(showInfoButton);
		content.add(firstName);
		content.add(lastName);
		content.add(email);
		content.add(allInfo);
		
		window.setSize(640, 480);
		window.setVisible(true);
	}

/*	#############################################################################################################
	NOTE THAT BOTH THE JBUTTON AND THE JTEXTFIELD ARE SHARING GTHE SAME LISTENER.
	THIS IS NOT REQUIRED BUT IT IS CONVENIENT. FYI INNER CLASSES ARE NOT ALLOWED 
	TO HAVE STATIC VARIABLES
*/
	// THIS CLASS IS A MEMBER OF THE JFRAME3 CLASS. THUS IT IS AN -INNER- CLASS
	class Listener implements ActionListener
	{
		public void actionPerformed(ActionEvent e)
		{	
			Component refToWhateverWasClicked = (Component) e.getSource();
			if (refToWhateverWasClicked == showInfoButton)
			{
				allInfo.setText( firstName.getText() + " " + lastName.getText() + " " + email.getText() );
			}
			else if (refToWhateverWasClicked == resetInfoButton)
			{
					firstName.setText( "replace with your first name" );
					lastName.setText( "replace with your last name" );
					email.setText( "replace with your email addy" );
					allInfo.setText( "ALL INFO DISPLAYED HERE" );
			}
		} // END ACTIONPERFORMED
	} // END INNER CLASS DEFINTION OF LISTENER

	// THE MAIN METHOD IS A ONE LINER, INSTANCING THE OUTER PUBLIC CLASS
	public static void main(String [] args)
	{
		new JFrame3();
	}
}

