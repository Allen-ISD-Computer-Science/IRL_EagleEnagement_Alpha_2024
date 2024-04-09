### Faculty SignUp:

```
<!DOCTYPE html>
<html>
  <head>
    <title>Faculty SignUp</title>
  </head>
  <body>
    <h1>Faculty SignUp</h1>
    <p>Hi #(name),</p>

	<p>Thank you for signing up for ConnectEDU. To complete your verification, click the link below:</p>
    <p><a href="#(PUBLIC_URL)/verify?code=#(verificationCode)">Verify Account</a></p>

	<p><small>If that link does not work, please navigate to the verification page manually and enter the code: <code>#(verificationCode)</code></small></p>

    <p>If you didn't attempt to sign up, please ignore this email.</p>

    <p>Regards,<br>ConnectEDU</p>
  </body>
</html>
```

### Faculty Forgot Pasword:

```
<!DOCTYPE html>
<html>
  <head>
    <title>Faculty Forgot Password</title>
  </head>
  <body>
    <h1>Faculty Forgot Password</h1>
    <p>Hi #(name),</p>

    <p>A password reset request has been made for your account. To reset your password, click the link below:</p>
    <p><a href="#(PUBLIC_URL)/verify?code=#(verificationCode)">Reset Password</a></p>

	<p><small>If that link does not work, please navigate to the reset page manually and enter the code: <code>#(verificationCode)</code></small></p>

    <p>If you didn't request a password reset, please ignore this email.</p>

    <p>Regards,<br>ConnectEDU</p>
  </body>
</html>
```

### Student SignUp:

```
<!DOCTYPE html>
<html>
  <head>
    <title>Student SignUp</title>
  </head>
  <body>
    <h1>Student SignUp</h1>
    <p>Hi #(name),</p>

    <p>Thank you for signing up for ConnectEDU. To complete your verification, copy the code below:</p>
    <p><code>#(verificationCode)</code></p>
	<p>After your have copied the code, go back to the ConnectEDU app and paste it into the "Code" field.</p>

    <p>If you didn't request a password reset, please ignore this email.</p>

    <p>Regards,<br>ConnectEDU</p>
  </body>
</html>
```

### Student Forgot Password:

```
<!DOCTYPE html>
<html>
  <head>
    <title>Student Forgot Password</title>
  </head>
  <body>
    <h1>Student Forgot Password</h1>
    <p>Hi #(name),</p>

    <p>A password reset request has been made for your account. To reset your password, copy the code below:</p>
    <p><code>#(verificationCode)</code></p>
	<p>After your have copied the code, go back to the ConnectEDU app and paste it into the "Code" field.</p>

    <p>If you didn't attempt to sign up, please ignore this email.</p>

    <p>Regards,<br>ConnectEDU</p>
  </body>
</html>
```
