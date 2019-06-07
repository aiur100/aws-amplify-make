# AWS Amplify App Creator

### Overview
This is a simple bash script that will create a simple boilerplate **AWS Amplify App**. This tool is intended for users that will be creating a Vanilla Javascript app.  The boiler plate app configuration steps and code is pulled directly from **AWS's own documentation**.

This is not currently a serious project. It's just something I made so that I could get a AWS Amplify starting point very quickly.  I put it here because I thought perhaps someone might make use of this.

**The reference documentation for this bash script:** https://aws-amplify.github.io/docs/js/start?ref=amplify-js-btn&platform=purejs

###If You REALLY want to change this...
* Even though I am not really taking this seriously, you are welcome to help and add any other functionality.

### Requirements
* All requirements laid in here must be completed: https://aws-amplify.github.io/docs/

### How to Use
* Make sure the script is executable on your machine
* `./aws-amplify-make.sh my-stupid-app`
* **NOTE:** This script will assume you want to make the app inside of the directory you are currently in.  Therefore, I know most of you probably don't want to do that.  So, you should move the script to your **home** directory and execute it there, or where your common work-space directory may be. **Or you could always just pass the whole path, which I think should work. (Like I said, I am not taking this very seriously)**
* **NOTE Numero Two:** This script will run you through the whole amp app set-up, so be prepared to answer questions. Also, please ensure you have your aws credentials set-up using the instructions provided in the **requirements** section above.