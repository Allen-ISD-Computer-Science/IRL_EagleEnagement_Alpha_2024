import * as React from "react";

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faEye, faEyeSlash, faSignIn, faUser } from '@fortawesome/free-solid-svg-icons'

function SignInPage(props) {
  const [email, setEmail] = React.useState("");
  const [password, setPassword] = React.useState("");
  const [passwordConfirm, setPasswordConfirm] = React.useState("");
  const [passwordType, setPasswordType] = React.useState("password");

  const [errorText, setErrorText] = React.useState("");

  /**
   * @param {String} email
   * @param {String} password 
   * @param {String} passwordConfirm 
   * @returns {Boolean}
   */
  const validateInfo = (email, password, passwordConfirm) => {
    if (email !== "" && (!email.includes("@") || !email.includes(".") || email.split("@").pop().length < 2 || email.split(".").pop().length < 2)) {
      setErrorText("Invalid email.");
      return false;
    }

    if (passwordConfirm !== password) {
      setErrorText("Passwords do not match.");
      console.log(passwordConfirm, password)
      return false;
    }
    setErrorText("");
    return true;
  }

  const canSignUp = () => {
    if (!validateInfo(email, password, passwordConfirm)) return false;

    if (email === "") {
      setErrorText("Email cannot be empty.");
      return false;
    }

    if (password === "") {
      setErrorText("Password cannot be empty.");
      return false;
    }

    return true;
  }

  const submitSignUp = async () => {
    if (!canSignUp()) return;

    const body = {
      email: email.toLowerCase(),
      password: btoa(password),
      passwordConfirm: btoa(passwordConfirm)
    }

    const res = await fetch("./signup", { method: "POST", body: JSON.stringify(body) });
    console.log(res);
  }

  return (
    <div className="justify-center items-center bg-neutral-200 min-h-[100vh] flex flex-col px-16 py-11 max-md:px-5">
      <span className="shadow-lg bg-blue-950 flex w-[650px] max-w-full flex-col mb-5 pl-12 pr-8 pb-2.5 rounded-2xl max-md:px-5 text-white">
        <img
          srcSet={process.env.PUBLIC_URL + "/assets/images/logo.png"}
          alt="Eagle Engagement Logo"
          className="h-40 mb-[-80px]"
        />
        <div className="justify-center items-center self-stretch flex flex-col mt-11 px-16 max-md:max-w-full max-md:mt-10 max-md:px-5">
          <div className="flex max-w-full flex-col items-center">
            <FontAwesomeIcon icon={faSignIn} size="4x" />
            <span className="text-center text-5xl font-bold whitespace-nowrap items-stretch self-stretch mt-5 pb-7 px-3 max-md:text-4xl">
              Welcome!
            </span>
            <span className="text-xl max-md:mb-4 max-md:text-l">
              Create your account
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
              onChange={(e) => { setEmail(e.target.value); validateInfo(e.target.value, password, passwordConfirm) }}
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
              onChange={(e) => { setPassword(e.target.value); validateInfo(email, e.target.value, passwordConfirm); }}
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
        <div className="mt-5">
          <span className="text-2xl max-md:text-xl">Confirm Password</span>
          <div className="flex items-center border-b border-white py-2 px-4 text-xl max-md:text-l">
            <input
              className="appearance-none bg-transparent border-none w-full placeholder-white text-gray-100 mr-3 py-1 leading-tight focus:outline-none"
              type={passwordType}
              placeholder=""
              aria-label="Confirm Password"
              value={passwordConfirm}
              onChange={(e) => { setPasswordConfirm(e.target.value); validateInfo(email, password, e.target.value); }}
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
          onClick={submitSignUp}
          type="button"
          className="text-center text-3xl font-semibold whitespace-nowrap justify-center items-center bg-blue-900 self-center w-[50%] max-w-full mt-11 px-16 py-2 rounded-xl max-md:text-2xl max-md:mt-10 max-md:px-5"
        >
          Create
        </button>
        <div className="text-center text-2xl self-center mt-11 leading-20 max-md:text-xl max-md:mt-10">
          <span>Already Have an Account? <a className="underline" href={process.env.PUBLIC_URL + "/login"}>Click</a></span>
        </div>
      </span>
    </div>
  );
}

export default SignInPage;
