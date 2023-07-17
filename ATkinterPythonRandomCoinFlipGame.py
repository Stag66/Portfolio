import random
import tkinter as tk
import tkinter as ttk 
from tkinter import *
from PIL import Image, ImageTk



window = tk.Tk()
window.title("Beat The House")
window.attributes('-fullscreen', True)
window.iconbitmap("icon.ico")
window.configure(background="black")

width= window.winfo_screenwidth()
height= window.winfo_screenheight()

#set screensize as fullscreen and not resizable
window.resizable(False, False)

# put image in a label and place label as background
imgTemp = Image.open("casino.jpg")
img2 = imgTemp.resize((2000,width))
img = ImageTk.PhotoImage(img2)

label = Label(window,image=img)
label.pack(side='top',fill=Y,expand=True)

menu = tk.Menu(window)
file_menu = tk.Menu(menu, tearoff= False)
file_menu.add_command(label = 'New', command = lambda: print('New File'))
menu.add_cascade(label = 'File', menu = file_menu)
window.configure(menu = menu)

print("Welcome to Beat The House!'. Players will start with $100 and attempt to predict the outcome of of 4 seperate coin tosses in order to profit from the casino. Gain or lose $25 with each outcome. Running out of money will disqualify you; Choose wisely!")

usermoney = 100

for x in range(0,4):
    user_choice = input("Heads(0) or Tails(1)?")
    flipresult = random.randint(0, 1)
    print("Flip result: " + str(flipresult))
    if user_choice == str(flipresult):
        print("Nice!")
        usermoney+=25;
    else: 
        print("Wrong! Good Try.")
        usermoney-=25;
      
    if(usermoney<0):
        print("You ran out of money!Try again.")
    else: print(usermoney)



print("You finished with $" + str(usermoney) + ". Good Work!")


window.mainloop()
