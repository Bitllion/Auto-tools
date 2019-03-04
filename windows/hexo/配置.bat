@echo off
echo Name :
set /p user_name=
echo Email :
set /p user_email=
git config --global user.name "%user_name%" 
git config --global user.email "%user_email%"
ssh-keygen -t rsa -C "%user_email%" && clip < C:\Users\BIT\.ssh\id_rsa.pub
echo Already copy your clip, Go to github settings gpg!
pause

