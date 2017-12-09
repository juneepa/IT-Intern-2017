import ftplib, os, urllib

## This code let you connect to the ftp server and upload files to certain directory 

## Connect and Log in to the ftp server
ftp = ftplib.FTP()
ftp.connect('some ftp server')
print (ftp.getwelcome(),"\n")

try:
    print("Logging In\n.\n.\n")
    ftp.login('some credentials', 'some password')
    print("Log In Successful!\n")
    
except:
    print("Failed to Log In")

## Upload files to sftp "testin" directory
print("Current Directory =", ftp.pwd())
ftp.cwd('/testin')
print("Current Directory =", ftp.pwd())
print("\n\n\n")

path = 'T:/dev/Some Folder_/Some_Folder/Outbox/'
for root, dirs, files in os.walk(path):
    for name in files:
        file = open(path + name, 'rb')
        storname = 'STOR ' + name
        
        try:
            ftp.storbinary(storname, file)
            print("Successfully Uploaded:", name, "\n")
            
        except:
            print("Failed to Upload:", name, "\n")
            
        file.close()

ftp.quit()
