Disclaimer: This is just what I did. some of this might actually be unneccesary, irrelevant or just plain weird. If so, let me know, and Ill try and update next time I install Raspbian.

So, to get everything we need up and running,
This is what i ended up with doing.

<a href="https://www.raspberrypi.org/downloads/raspbian/">Download Raspbian</a> and install in using <a href="https://etcher.io/">etcher.</a>
A simple guide for this can be found <a href="https://www.raspberrypi.org/documentation/installation/installing-images/README.md">here</a>.

Insert the sd card in the Pi, and boot it up.

After initial setup, start bash (console),  and do the following
<ul>
 	<li>Expand disk to use all free space on sd card using the following command</li>
</ul>
<pre class="psconsole">sudo raspi-config --expand-rootfs</pre>
<ul>
 	<li>Configure network to use WLAN. This is espacialy needed if you, like me, have a hidden SSID which is not supported in the gui configuration.</li>
</ul>
<pre class="psconsole">sudo nano /etc/wpa_supplicant/wpa_supplicant.conf 
</pre>
I found a guide <a href="https://raspi.tv/2017/how-to-auto-connect-your-raspberry-pi-to-a-hidden-ssid-wifi-network">here</a> of how to configure it, and my conf file ended up looking like this
<pre class="psconsole">network={
        ssid="insert_your_hidden_SSID_here"
        scan_ssid=1
        psk="insert_your_wifi_password_here"
        key_mgmt=WPA-PSK
}
</pre>
And after doing this, I did a reboot to get connected to my network.
<pre class="psconsole">sudo reboot
</pre>
<ul>
 	<li>Next step, Install prereqs for PowerShell and PowerShell IoT.
According to the PowerShell install instructions, we need libunwind8.
It seems to be some kind of prereq for CoreCLR 2.0 to work properly as it can generate really weird errors if it is missing.</li>
</ul>
<pre class="psconsole">sudo apt-get install libunwind8
</pre>
<ul>
 	<li>Install Powershell. Download the latest build from <a href="https://github.com/PowerShell/PowerShell">here</a>
the file you get is a gziped file, that you can install using the following command.</li>
</ul>
<pre class="psconsole">mkdir ~/powershell
tar -xvf ./Downloads/powershell-6.0.2-linux-arm32.tar.gz -C ~/powershell/
</pre>
This will install powershell in the ~/powershell folder. Feel free to use any folder you like.
<ul>
 	<li>Install Mono framework. PowerShell-IoT is based on the unosquare raspberryio framework, and that in turn requires a Mono version greater than 4.6 installed. The following commands will upgrade your installed packages, and install mono for you.</li>
</ul>
<pre class="psconsole">sudo apt-get update
sudo apt-get upgrade
sudo apt-get install mono-complete
sudo apt-get install dirmngr
# Verify mono version -gt 4.6
mono --version
</pre>
<ul>
 	<li>Finaly we install the unosquare raspberyio framework that PowerShell-IoT is based on using nuget. First off, make sure we have nuget installed.</li>
</ul>
<pre class="psconsole">sudo apt-get install nuget
</pre>
<ul>
 	<li>Because the nuget version distributed is old, you will get a really weird error when trying to install stuff. Update Nuget exacutable by running the following command.</li>
</ul>
<pre class="psconsole">sudo nuget update -self
</pre>
<ul>
 	<li>And finally, we can install raspberryio.</li>
</ul>
<pre class="psconsole">nuget install Unosquare.Raspberry.IO
</pre>
<ul>
 	<li>It's time to enter the world of powershell. Start Powershell using the following command.</li>
</ul>
<pre class="psconsole">sudo WIRINGPI_CODES=1 ~/powershell/pwsh
</pre>
What is this WIRINGPI_CODES? you ask. a well structured and good explanation can be found on the <a href="https://github.com/PowerShell/PowerShell-IoT#about-wiringpi_codes-environment-variable">PowerShell IoT Github page.</a>

***There was supposed to be somehing here, but I messed up and forgot to bring theese images from the now deleted old blog. sorry.***

Photo from terminal on Raspbian. I have no idea how to do screenshots on Linux. And I know i didnt use the wiringpi variable. Bad Bjompen.

In the next chapter we will finally start to look in to some code and the first project: lighting a Led. 'til then, stay cool in the heatwave.