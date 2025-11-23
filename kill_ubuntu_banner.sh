Bash# 1. Disable the default Ubuntu MOTD spam (the part that shows updates, ESM, etc.)
sudo chmod -x /etc/update-motd.d/10-help-text
sudo chmod -x /etc/update-motd.d/50-motd-news
sudo chmod -x /etc/update-motd.d/50-landscape-sysinfo
sudo chmod -x /etc/update-motd.d/90-updates-available
sudo chmod -x /etc/update-motd.d/91-contract-ua-esm-status
sudo chmod -x /etc/update-motd.d/92-unattended-upgrades
sudo chmod -x /etc/update-motd.d/95-hwe-eol   # if it exists

# 2. Also kill the “Last login:” line that Ubuntu forces (optional, but cleaner)
sudo chmod -x /etc/update-motd.d/00-header 2>/dev/null || true

# 3. Make sure only your custom MOTD shows (static version – fastest & cleanest)
sudo rm -f /etc/motd
sudo ln -sf /run/motd.dynamic /etc/motd 2>/dev/null || true

# 4. Force a one-line static MOTD that you fully control
sudo bash -c 'cat > /etc/motd << "EOF"

 #####  ######     #    #     # ### ####### #     # ######  ######  ### #     # ####### 
#     # #     #   # #   #     #  #     #     #   #  #     # #     #  #  #     # #       
#       #     #  #   #  #     #  #     #      # #   #     # #     #  #  #     # #       
#  #### ######  #     # #     #  #     #       #    #     # ######   #  #     # #####   
#     # #   #   #######  #   #   #     #       #    #     # #   #    #   #   #  #       
#     # #    #  #     #   # #    #     #       #    #     # #    #   #    # #   #       
 #####  #     # #     #    #    ###    #       #    ######  #     # ###    #    ####### 
		814NORTH Development Node
        High-dimensional computation online
        Welcome, operator. Gravitational pull engaged.

EOF'
