# -*- mode: muttrc;-*-
# memes@matthewemes.com settings
# $Id: $

# Switch to memes@matthewemes.com identity
set signature="~/.mutt/memes.sig"
set realname="Matthew Emes"
set from="memes@matthewemes.com"
my_hdr From: memes@matthewemes.com
my_hdr Reply-To: memes@matthewemes.com

# IMAP configuration for memes@matthewemes.com remote mail
set imap_user="memes@matthewemes.com"
set mail_check=90
set timeout=15
set imap_check_subscribed
unset imap_list_subscribed
set folder=imaps://memes@matthewemes.com@imap.1and1.com/
set spoolfile=+INBOX
set record=+INBOX
set postponed=+Drafts
mailboxes +INBOX

# Cache settings
set header_cache="~/.mutt/cache"

# SMTP configuration
set smtp_url="smtp://memes@matthewemes.com@smtp.1and1.com:587"

# Send hooks
send-hook . 'set signature="~/.mutt/memes.sig"'

# Remove the custom macros
source ~/.mutt/mutt.unmacros
