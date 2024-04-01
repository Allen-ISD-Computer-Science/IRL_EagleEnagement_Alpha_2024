import * as React from "react";

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faEye, faEyeSlash, faSignIn, faUser } from '@fortawesome/free-solid-svg-icons'

import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

function SignInPage(props) {

  const [email, setEmail] = React.useState("");
  const [password, setPassword] = React.useState("");
  const [passwordType, setPasswordType] = React.useState("password");

  const [errorText, setErrorText] = React.useState("");

  const [didReq, setDidReq] = React.useState(false);

  const validateInfo = (email) => {
    if (email !== "" && (!email.includes("@") || !email.includes(".") || email.split("@").pop().length < 2 || email.split(".").pop().length < 2)) {
      setErrorText("Invalid email.");
      return false;
    }
    setErrorText("");
    return true;
  }

  const canLogin = () => {
    if (!validateInfo(email)) return false;

    if (email === "") {
      setErrorText("Email cannot be empty.");
      return false;
    }

    if (password === "") {
      setErrorText("Password cannot be empty.");
      return false;
    }

    if (didReq) {
      setErrorText("Already sent request! Please wait.");
      return false;
    }

    return true;
  }

  const submitLogin = async () => {
    if (!canLogin()) return;

    const hash = btoa(email + ":" + password);
    const headers = { 'Authorization': `Basic ${hash}` };

    try {
      const res = await fetch("./login", { method: "POST", headers });
      console.log(res);

      setDidReq(false);

      if (res.status === 200) {
        toast.success("Successfully logged in. Redirecting...", {
          position: "top-right",
          autoClose: 2000,
          closeOnClick: true,
          pauseOnHover: true,
          theme: "light"
        });
        setTimeout(() => {
          const url = new URL(window.location.href);

          console.log(url.searchParams);

          if (url.searchParams.has("redirect")) {
            window.location.href = process.env.PUBLIC_URL + url.searchParams.get("redirect");
          } else {
            window.location.href = process.env.PUBLIC_URL + "/dashboard";
          }
        }, 1000);
      } else {
        toast.error(res.status === 401 ? "Invalid Credentials." : res.statusText, {
          position: "top-right",
          autoClose: 2000,
          closeOnClick: true,
          pauseOnHover: true,
          theme: "light"
        });
      }
    } catch (e) {
      console.error(e);
    }
  }

  return (
    <form
      action="./login"
      method="/post"
      className="justify-center items-center bg-neutral-200 min-h-[100vh] flex flex-col px-16 py-11 max-md:px-5"
    >
      <ToastContainer
        position="top-right"
        autoClose={2000}
        hideProgressBar={false}
        newestOnTop
        closeOnClick
        pauseOnFocusLoss
        pauseOnHover
        theme="light"
      />

      <span className="shadow-lg bg-blue-950 flex w-[650px] max-w-full flex-col mb-5 pl-12 pr-8 pb-2.5 rounded-2xl max-md:px-5 text-white">
        <img
          srcSet={process.env.PUBLIC_URL + "/assets/images/logo.svg"}
          alt="ConnectEdu Logo"
          className="h-40 mt-6"
        />
        <div className="justify-center items-center self-stretch flex flex-col mt-6 px-16 max-md:max-w-full max-md:mt-10 max-md:px-5">
          <div className="flex max-w-full flex-col items-center">
            <FontAwesomeIcon icon={faSignIn} size="4x" />
            <span className="text-center text-5xl font-bold whitespace-nowrap items-stretch self-stretch mt-5 pb-7 px-3 max-md:text-4xl">
              Welcome!
            </span>
            <span className="text-xl max-md:mb-4 max-md:text-l">
              Sign into your account
            </span>
          </div>
        </div>
        <div>
          <span className="text-2xl max-md:text-xl">Email</span>
          <div className="flex items-center border-b border-white py-2 px-4 text-xl max-md:text-l">
            <input
              className="appearance-none bg-transparent border-none w-full placeholder-white text-gray-100 mr-3 py-1 leading-tight focus:outline-none"
              type="email"
              placeholder=" "
              aria-label="Email"
              value={email}
              onChange={(e) => { setEmail(e.target.value); validateInfo(e.target.value) }}
            />
            <FontAwesomeIcon icon={faUser} size="sm" />
          </div>
        </div>
        <div className="mt-5">
          <span className="text-2xl max-md:text-xl">Password</span>
          <div className="flex items-center border-b border-white py-2 px-4 text-xl max-md:text-l">
            <input
              className="appearance-none bg-transparent border-none w-full placeholder-white text-gray-100 mr-3 py-1 leading-tight focus:outline-none"
              type={passwordType}
              placeholder=""
              aria-label="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") {
                  submitLogin();
                }
              }}

            />
            <button
              id="togglePassword"
              type="button"
              onClick={() => {
                setPasswordType(passwordType === "password" ? "text" : "password");
              }}
            >
              <FontAwesomeIcon
                icon={passwordType === "password" ? faEyeSlash : faEye}
                size="sm"
                style={{ width: "25px" }}
              />
            </button>
          </div>
        </div>
        <span className={`text-red-500 text-center mt-5 ${errorText ? "opacity-100" : "opacity-0"}`}>
          {errorText ? `*${errorText}` : "|"}
        </span>
        <button
          onClick={submitLogin}
          type="button"
          className="text-center text-3xl font-semibold whitespace-nowrap justify-center items-center bg-blue-900 self-center w-[50%] max-w-full mt-11 px-16 py-2 rounded-xl max-md:text-2xl max-md:mt-10 max-md:px-5"
        >
          Login
        </button>
        <div className="text-center text-2xl self-center mt-11 leading-20 max-md:text-xl max-md:mt-10">
          <span>Don't Have an Account? <a className="underline" href={process.env.PUBLIC_URL + "/signup"}>Click</a></span>
          <br />
          <span>Forgot Your Password? <a className="underline" href={process.env.PUBLIC_URL + "/forgotpassword"}>Click</a></span>
        </div>
      </span>
    </form>
  );
}

export default SignInPage;
