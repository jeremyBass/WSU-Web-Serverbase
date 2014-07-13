###########################################################
###########################################################
# iptables
###########################################################
/etc/sysconfig/iptables:
  file.managed:
    - source: salt://config/iptables/iptables
    - user: root
    - group: root
    - mode: 600
  cmd.run: #insure it's going to run on windows hosts.. note it's files as folders the git messes up
    - name: dos2unix /etc/sysconfig/iptables
    - require:
      - pkg: dos2unix
    
iptables:
  pkg.installed:
    - name: iptables
  service.running:
    - watch:
      - file: /etc/sysconfig/iptables

# Set iptables to run in levels 2345.
iptables-reboot-auto:
  cmd.run:
    - name: chkconfig --level 2345 iptables on
    - cwd: /
    - require:
      - pkg: iptables



###########################################################
###########################################################
# fail2ban
###########################################################
fail2ban:
  pkg.installed:
    - name: fail2ban


/etc/fail2ban/jail.local:
  file.managed:
    - source: salt://config/fail2ban/jail.local
    - user: root
    - group: root
    - mode: 600

#we want to store the ip blocked
/etc/fail2ban/ip.blacklist:
  file.managed:
    - user: root
    - group: root
    - mode: 600



# set up so passive filters that look for some we app logs like spam from WP and Magento
# this are only example defaults.  Should be altered to best fit with least amount Ad hoc
/etc/fail2ban/filter.d/spam-log.conf:
  file.managed:
    - source: salt://config/fail2ban/filter.d/spam-log.conf
    - user: root
    - group: root
    - mode: 600

# Provide the actions directory for fail2ban
/etc/fail2ban/actions.d:
  file.directory:
    - user: root
    - group: root
    - mode: 600
    - makedirs: true


/etc/fail2ban/actions.d/mail.-nmap.conf:
  file.managed:
    - source: salt://config/fail2ban/actions.d/mail.-nmap.conf
    - user: root
    - group: root
    - mode: 600
    

# Set fail2ban to run in levels 2345.
fail2ban-reboot-auto:
  cmd.run:
    - name: chkconfig --level 2345 fail2ban on
    - cwd: /
    - require:
      - pkg: fail2ban
    