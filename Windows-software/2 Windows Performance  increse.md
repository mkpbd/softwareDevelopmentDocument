
1.  Select  This PC Icon   Right button Click   then go to  Properties  and click properties  ![[Windows-software/images/Screenshot_118.png]]
2.  select About     go  to Advanced System and Settings    and click this 

![[Screenshot_119 2.png]]

3.  select Advanced  tab  go to performance   and click  settings  button 
 ![[Screenshot_121.png]]

4.  check radio button  Adjust for best Performance 
![[Screenshot_122.png]]



##   Increase  Performance  with thread  when this is boot 

1.   key board   win + r  Press   
2.  then show run   write msconfig 
![[Screenshot_123.png]]

3. select boot Tab  and  Advance options 
   
4. ![[Screenshot_124.png]]
   number of processors Check and give Max value of your computer  then ok
   
![[Screenshot_125.png]]
5. select boot  tab  and select No GUI boot  Check box  then apply   and your  PC will be restart


##  Increase speed 

1.   search   services   and open  service file 
2.  go to   sysMain    option click   open  dialog  then  automatic option change  to disable  and stop  then apply 
3. ![[Screenshot_126.png]]



## When   your CPU or processor   100% show then  
 1.  go to  CMD or powerShell    open as  Run   Administrator 
	 run commdand 
	1. 	 SETACVALUEINDEX SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 000
	2.            SETACTIVE SCHEME_CURRENT


# Reasons for High CPU Usage


**2. [Svchost.exe](https://www.minitool.com/lib/svchost-exe.html) (netscvs) Process**

When you open the [Task Manager](https://www.minitool.com/lib/task-manager.html), you might have noticed that the svchost.exe (netscvs) process causes high memory or CPU usage. Sometimes this process is associated with malware, but it is a legal system-critical Windows process.

**3. WMI Provider Host (WmiPrvSE.EXE)**

The WMI Provider Host process is part of Windows, which helps organize monitor and troubleshoot large numbers of systems on the network. However, sometimes it will go out of control.

**4. There Is an Annoying Antivirus or a Virus**

On the one hand, an annoying antivirus will cause high CPU usage. On the other hand, a virus also can cause high CPU usage.

**5. System [Idle Process](https://www.minitool.com/lib/system-idle-process-021.html)**

In fact, the system idle process is just a thread that consumes CPU cycles, and it will not be used. Thus, it’s a reason for high CPU usage.

![[Pasted image 20240830141557.png]]

## Solutions to Fix the High CPU Usage

In general, you can stay away from demanding applications to avoid high CPU usage. But sometimes it will go out of control since there is a bug in the process like the notorious WmiPrvSE.exe. You don’t need to worry about that because then I will introduce 8 solutions to help you lower the high CPU usage.

### Solution 1: Restart the WMI Provider Host

If the CPU usage is very high, and you’re not running any program that would impact it, it’s not normal. You can open **Task Manager** to check it.

Recently Microsoft has pulled its official fix, the only thing you can do is to restart the service manually. Here is how to fix the CPU 100%:

**Step 1:** Search for **Services** and open it.

**Step 2:** In the window, find **Application Management** and right-click it. Then select **Restart**.

![[Pasted image 20240830145653.png]]
After you do this operation, the high CPU usage will become lower. If not, you can try the next solution.

**Tip:** You can also stop the service entirely and simply restart your computer.


### Solution 2: Use the Event Viewer to Identify the Issues

If the issue with WmiPrvSE.exe still exists, you can identify its cause by using the Windows Event Viewer. Maybe there is another system process that makes WMI provider host keep busy, resulting in high CPU usage. Here is how to fix CPU 100%.

**Step 1:** Right-click the **Start** button and select **Event Viewer** to open it.

**Step 2:** Choose **Applications and Service Logs** in the left and choose **Microsoft**. Then click **Windows**, **WMI-Activity**, and **Operational** successively to open them.

**Step 3:** Now you should find recent Error entries by scrolling through the list of operational events. For each Error, identify the ClientProcessId.


![[Pasted image 20240830145754.jpg]]

**Note:** Every time you restart the process, the ClientProcessId will change, so checking for older errors makes no sense.

If you suspect that one of these processes is causing the high CPU usage, you can use its ID to find it in the Task Manager and identify the faulty process to fix the high CPU usage.


### Solution 3: End the Processes that Cause High CPU Usage

When you notice that the PC is getting slower than usual and the CPU 100%, you can try the Task Manager to find which processes are causing high CPU usage. Here is how to fix the 100% CPU usage issue.

**Step 1:** Search for **Task Manager** and open it.

**Step 2:** Click the **CPU** column header to sort the processes by CPU usage and check which processes cause your CPU becoming higher.

**Step 3:** Right-click the process that consumes lots of your CPU and then you should click **End task** to finish this process.


![[Pasted image 20240830145956.png]]
**Tip:** You should Google the process name to check whether it is safe to end or not before you end the process.

### Solution 5: Reset Your Power Plan

Power Options has a significant impact on your PC’s performance. If your computer is on Power saver, especially you have changed its’ plan settings, it will cause your CPU becoming higher. The steps to fix high CPU usage are as follows.

**Step 1:** Choose **Hardware and Sound** after you launch **Control Panel**, and click **Power Options**.

**Step 2:** Then choose **Balanced** if your computer is on **Power saver**.

![[Pasted image 20240830150058.png]]

**Step 3:** Then click **Change plan settings** that is next to the Balanced.

**Step 4:** Now, you just need to click **Restore default** **settings for this plan** and click **OK** to make the changes.

![[Pasted image 20240830150130.png]]

### Solution 6: Modify Settings in Registry Editor

This issue may be caused by Cortana in Windows 10/11. Thus, if you enabled Cortana, you may encounter the situation that CPU 100%. If you seldom use Cortana, try modifying settings in Registry Editor to see if you can fix this issue. Here is how to lower the high CPU usage:


**Step 1:** Press the **Windows logo** key and the **R** key at the same time to open the **Run** dialog.

**Step 2:** Type **regedit** and then press **Enter** to open **Registry Editor**. You’ll be prompted for permission and please click **Yes** to open it.>

**Step 3:** Follow the path to locate the correct system files: **HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TokenBroker**.

![[Pasted image 20240830150236.png]]

**Step 4:** Right-click the **Start** entry on the right side of the pane and select **Modify….**.

**Step 5:** Then change the Value data to 4 and click **OK** to save the change.

After the change, some features of your Cortana will be affected. If you often use it, this option might not be suitable for you.

Then you can check if this annoying issue remains. If not, you have resolved this issue successfully. If this problem still remains, there is the last solution for you, you can try it.

### Solution 7: Turn Windows Notification Settings Off

Windows notification settings on Windows 10/11 PCs may trigger CPU 100%. You can follow the steps below to modify the Windows notification settings to fix the issue:

**Step 1:** You should click the **Start** button and click **Settings** to open the **Windows Setting**.

**Step 2:** Then choose **System** and click **Notifications & actions** on the left side of the pane.

**Step 3:** At last, you just need to turn off the feature **Get notifications from apps and other senders**.

![[Pasted image 20240830150320.png]]



