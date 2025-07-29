# Information Gathering using Nmap, crt.sh, WHOIS, Subfinder, and Nslookup (Linux)

To get started, you’ll need to install the required tools. Since this project is fairly common and straightforward, I’ve not included a separate install script. This is a simple but effective script for basic reconnaissance.<br>

Note: Check the requirements.txt file and install the necessary tools using your system’s package manager.<br>

Here’s a quick install command for Debian-based systems:<br>
```
sudo apt install -y nmap awk subfinder dnsutils whois curl
```
Depending on your Linux distribution, some package names may vary.<br>

Once installation is complete, give the script execution permission:<br>
```
sudo chmod +x main.sh
```
Then run the script:<br>
```
./main.sh
```
It will prompt you to enter a domain name (e.g., example.com — without https://).<br>

The script will create a rawdata directory to store output files. If a directory named rawdata already exists, remove it beforehand to avoid overwriting or merging old data.<br>

Notes<br>
All raw outputs are saved inside the rawdata/ folder.<br>

Feel free to give feedback, suggest improvements, or report bugs.<br>

Contributions and feature requests are welcome!<br>
