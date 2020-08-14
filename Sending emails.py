# This script is to automatically send an email

import smtplib

gmail_user = 'jsaraviadrago'
gmail_password = 'chipigrafijc96'

sent_from = 'jsaraviadrago@gmail.com'
to = 'juliocesar@hospitapp.pe'
subject = 'Friendly reminder'
body = 'Este es solo un friendly reminder. \n\n JC'

email_text = '''Subject: {}\n\n{}
From: %s
To: %s
Subject: %s

%s
'''.format(subject, body) % (sent_from, ", ".join(to), subject, body)

try:
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.ehlo()
    server.login(gmail_user, gmail_password)
    server.sendmail(sent_from, to, email_text)
    server.close()

    print('Email sent')
except:
    print('Something went wrong')




