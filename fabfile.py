#!/usr/bin/python
from fabric.operations import local as lrun, run
from fabric.api import env,cd,run,settings,task
from fabric.colors import cyan,red
import sys
# Usage for VXML -> fab domain_vxml -H <hostname>
# Usage for VCS -> fab domain_vcs -H <hostname>
env.user = 'root'
# Take the host name argument and split it to get the data center.
host=sys.argv[3]
dc=host.split('.')
# VXML use fab domain_vxml -H <hostname>
# Function to compare the dc value and execute the function to move to appropiate meter server.
def domain_vxml():
 if dc[1] in ('orl','las'):
  meter_us_vxml()
 elif dc[1] in ('sin','hkg'):
  meter_apac_vxml()
 elif dc[1] in ('lhr'):
  meter_lhr_vxml()
 else:
  meter_fra_vxml()
# One of the following functions will be executed based off the condition above.


def meter_us_vxml():
  with cd('/opt/voxeo/prophecy/logs/vxml'):
   date=int(run('date +%s'))
   filedate = int(run('date -r motmeter* +%s'))
   if date-filedate > 300:
     print(cyan("Motmeter file is not growing....Transferring file to meter server"))
     run('find . -name "motmeter*" -type f -exec mv {} {}_$(hostname)_$(date +%F) \;')
     print(cyan("Compressing the file..."))
     run('gzip -9v motmeter*')
     print(cyan("Moving file to meter server"))
     with settings(prompts={'''Password: ''' : 'Blu3Bl00d'}):
      run('rsync --remove-source-files -v motmeter* root@meter1.las.aspect-cloud.net:/data/recovery/vxml')
     with settings(warn_only=True):
      run('ls -l motmeter*')
      print(cyan("Motmeter file has been moved to meter server"))
   else:
     print(red("Motmeter file is growing...Exiting"))


def meter_apac_vxml():
  with cd('/opt/voxeo/prophecy/logs/vxml'):
   date=int(run('date +%s'))
   filedate = int(run('date -r motmeter* +%s'))
   if date-filedate > 300:
     print(cyan("Motmeter file is not growing....Transferring file to meter server"))
     run('find . -name "motmeter*" -type f -exec mv {} {}_$(hostname)_$(date +%F) \;')
     print(cyan("Compressing the file..."))
     run('gzip -9v motmeter*')
     print(cyan("Moving file to meter server"))
     with settings(prompts={'''rjohn@tools1.orl.voxeo.net's password: ''' : 'Aspect123$'}):
      run('scp -p motmeter* rjohn@tools1.orl.voxeo.net:/home/rjohn/vcs_apac/')
     with settings(warn_only=True):
      run('ls -l motmeter*')
      print(cyan("Motmeter file has been moved to meter server"))
      run('rm -rf motmeter*')
      filemove_vxml()
   else:
     print(red("Motmeter file is growing...Exiting"))

def filemove_vxml():
	env.run = lrun
	env.hosts = ['localhost']
	env.run('rsync --remove-source-files -v /home/rjohn/vcs_apac/* root@meter1.lhr.aspect-cloud.net:/data/recovery/vxml/')

def meter_lhr_vxml():
  with cd('/opt/voxeo/prophecy/logs/vxml'):
   date=int(run('date +%s'))
   filedate = int(run('date -r motmeter* +%s'))
   if date-filedate > 300:
     print(cyan("Motmeter file is not growing....Transferring file to meter server"))
     run('find . -name "motmeter*" -type f -exec mv {} {}_$(hostname)_$(date +%F) \;')
     print(cyan("Compressing the file..."))
     run('gzip -9v motmeter*')
     print(cyan("Moving file to meter server"))
     with settings(prompts={'''root@meter1.lhr.aspect-cloud.net's password: ''' : 'Blu3Bl00d'}):
      run('rsync --remove-source-files -v motmeter* meter1.lhr.aspect-cloud.net:/data/recovery/vxml')
     with settings(warn_only=True):
      run('ls -l motmeter*')
      print(cyan("Motmeter file has been moved to meter server"))
   else:
     print(red("Motmeter file is growing...Exiting"))


def meter_fra_vxml():
  with cd('/opt/voxeo/prophecy/logs/vxml'):
   date=int(run('date +%s'))
   filedate = int(run('date -r motmeter* +%s'))
   if date-filedate > 300:
     print(cyan("Motmeter file is not growing....Transferring file to meter server"))
     run('find . -name "motmeter*" -type f -exec mv {} {}_$(hostname)_$(date +%F) \;')
     print(cyan("Compressing the file..."))
     run('gzip -9v motmeter*')
     print(cyan("Moving file to meter server"))
     with settings(prompts={'''root@meter1.fra.aspect-cloud.net's password: ''' : 'Blu3Bl00d'}):
      run('rsync --remove-source-files -v motmeter* meter1.fra.aspect-cloud.net:/data/recovery/vxml')
     with settings(warn_only=True):
      run('ls -l motmeter*')
      print(cyan("Motmeter file has been moved to meter server"))
   else:
     print(red("Motmeter file is growing...Exiting"))
# Take the host name argument and split it to get the data center.
#host=sys.argv[3]
#dc=host.split('.')
# VCS : Use fab domain_vcs -H <hostname>
# Function to compare the dc value and execute the function to move to appropiate meter server.
def domain_vcs():
 if dc[1] in ('orl','las'):
  meter_us_vcs()
 elif dc[1] in ('sin','hkg'):
  meter_apac_vcs()
 elif dc[1] in ('lhr'):
  meter_lhr_vcs()
 else:
  meter_fra_vcs()
# One of the following functions will be executed based off the condition above.


def meter_us_vcs():
  with cd('/opt/voxeo/prophecy/logs/vcs'):
   date=int(run('date +%s'))
   filedate = int(run('date -r metering_cannot_send.log +%s'))
   if date-filedate > 300:
     print(cyan("Metering file is not growing....Transferring file to meter server"))
     run('find . -name "metering_cannot_send.log" -type f -exec mv {} {}_$(hostname)_$(date +%F) \;')
     print(cyan("Compressing the file..."))
     run('gzip -9v metering_cannot_send.log*')
     print(cyan("Moving file to meter server"))
     with settings(prompts={'''Password: ''' : 'Blu3Bl00d'}):
      run('rsync --remove-source-files -v metering* root@meter1.las.aspect-cloud.net:/data/recovery/vcs')
     with settings(warn_only=True):
      run('ls -l metering*')
      print(cyan("Meter file has been moved to meter server"))
   else:
     print(red("Meter file is growing...Exiting"))


def meter_apac_vcs():
  with cd('/opt/voxeo/prophecy/logs/vcs'):
   date=int(run('date +%s'))
   filedate = int(run('date -r metering_cannot_send.log +%s'))
   if date-filedate > 3:
     print(cyan("Meter file is not growing....Transferring file to meter server"))
     run('find . -name "metering_cannot_send*" -type f -exec mv {} {}_$(hostname)_$(date +%F) \;')
     print(cyan("Compressing the file..."))
     run('gzip -9v metering_cannot_send*')
     print(cyan("Moving file to tools server"))
     with settings(prompts={'''rjohn@tools1.orl.voxeo.net's password: ''' : 'Aspect123$'}):
      run('scp -p meter* rjohn@tools1.orl.voxeo.net:/home/rjohn/vcs_apac/')
     with settings(warn_only=True):
      run('ls -l metering*')
      print(cyan("Meter file has been moved to meter server"))
      run('rm -rf mete*')
      filemove_vcs()
   else:
     print(red("Meter file is growing...Exiting"))

def filemove_vcs():
	env.run = lrun
	env.hosts = ['localhost']
	env.run('rsync --remove-source-files -v /home/rjohn/vcs_apac/* root@meter1.lhr.aspect-cloud.net:/data/recovery/vcs/')


def meter_lhr_vcs():
  with cd('/opt/voxeo/prophecy/logs/vcs'):
   date=int(run('date +%s'))
   filedate = int(run('date -r metering_cannot_send.log +%s'))
   if date-filedate > 300:
     print(cyan("Meter file is not growing....Transferring file to meter server"))
     run('find . -name "metering_cannot_send.log" -type f -exec mv {} {}_$(hostname)_$(date +%F) \;')
     print(cyan("Compressing the file..."))
     run('gzip -9v metering_cannot_send.log*')
     print(cyan("Moving file to meter server"))
     with settings(prompts={'''root@meter1.lhr.aspect-cloud.net's password: ''' : 'Blu3Bl00d'}):
      run('rsync --remove-source-files -v metering* meter1.fra.aspect-cloud.net:/data/recovery/vcs')
     with settings(warn_only=True):
      run('ls -l metering*')
      print(cyan("Meter file has been moved to meter server"))
   else:
     print(red("Meter file is growing...Exiting"))


def meter_fra_vcs():
  with cd('/opt/voxeo/prophecy/logs/vcs'):
   date=int(run('date +%s'))
   filedate = int(run('date -r metering_cannot_send.log +%s'))
   if date-filedate > 300:
     print(cyan("Meter file is not growing....Transferring file to meter server"))
     run('find . -name "metering_cannot_send.log" -type f -exec mv {} {}_$(hostname)_$(date +%F) \;')
     print(cyan("Compressing the file..."))
     run('gzip -9v metering_cannot_send.log*')
     print(cyan("Moving file to meter server"))
     with settings(prompts={'''root@meter1.fra.aspect-cloud.net's password: ''' : 'Blu3Bl00d'}):
      run('rsync --remove-source-files -v metering* meter1.fra.aspect-cloud.net:/data/recovery/vcs')
     with settings(warn_only=True):
      run('ls -l metering*')
      print(cyan("Meter file has been moved to meter server"))
   else:
     print(red("Meter file is growing...Exiting"))
