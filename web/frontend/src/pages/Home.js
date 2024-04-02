import * as React from "react";

function HomePage(props) {
  return (
    <div className="bg-neutral-200 flex flex-col justify-center items-stretch">
      <section className="flex-col overflow-hidden relative flex min-h-[1000px] w-full items-stretch pb-12 px-5 max-md:max-w-full">
        <img
          loading="lazy"
          srcSet={process.env.PUBLIC_URL + "/assets/images/homePageImage.png"}
          alt="Allen High School Football Game"
          className="brightness-50 absolute h-full w-full object-cover object-center inset-0 max-h-[100vh] max-md:max-h-[80vh]"
        />
        <nav className="justify-between items-stretch flex w-full gap-5 sticky top-0 max-md:w-full max-md:flex-wrap">
          <span className="flex flex-col items-stretch">
            <img
              srcSet={process.env.PUBLIC_URL + "/assets/images/logo.svg"}
              alt="ConnectEDU Logo"
            />
          </span>
          <div className="drop-shadow-[0_1.2px_1.2px_rgba(0,0,0,0.8)] justify-center w-[66%] py-8 self-start max-md:w-full max-md:pr-5">
            <div className="gap-5 flex max-md:flex-col max-md:items-stretch max-md:gap-0">
              <div className="flex flex-col items-stretch w-[33%] max-md:w-full max-md:ml-0">
                <div className="text-white text-center text-2xl font-bold uppercase max-md:mt-10">
                  <a
                    href="#about"
                    className="transition-colors hover:text-blue-500"
                  >About</a>
                </div>
              </div>
              <div className="flex flex-col items-stretch w-[33%] ml-5 max-md:w-full max-md:ml-0">
                <div className="text-white text-center text-2xl font-bold uppercase w-[100%] max-md:mt-10">
                  <a
                    href={process.env.PUBLIC_URL + "/download"}
                    className="transition-colors hover:text-blue-500"
                  >Student Download
                  </a>
                </div>
              </div>
              <div className="flex flex-col items-stretch w-[33%] ml-5 max-md:w-full max-md:ml-0">
                <div className="text-white text-2xl font-bold uppercase text-center max-md:mt-10">
                  <a
                    href={process.env.PUBLIC_URL + "/login"}
                    className="transition-colors hover:text-blue-500"
                  >Faculty Login
                  </a>
                </div>
              </div>
            </div>
          </div>
        </nav>
        <div className="drop-shadow-[0_1.2px_1.2px_rgba(0,0,0,0.8)] relative text-white text-center text-5xl font-extrabold max-w-[700px] self-center mt-40 mb-72 max-md:max-w-full max-md:text-4xl max-md:my-10">
          <span className="text-3xl text-white max-md:!pb-10">|</span>
          <br />
          <span>
            CONNECTEDU
          </span>
          <br />
          <span className="text-4xl max-md:text-2xl text-white max-md:!leading-10">
            A Student Engagement App
          </span>
        </div>
      </section>

      <section>
        <h2
          id="about"
          className="text-blue-950 text-center text-5xl font-extrabold uppercase max-md:text-4xl"
        >About</h2>
        <div className="mt-10 py-10 px-20 text-xl max-md:max-w-full max-md:my-10">
          <span>
            ConnectEDU is a cutting-edge student engagement app designed to streamline the process of discovering and participating in various events and organizations.
            The app provides a simple and intuitive interface for students to find and join clubs, sports, and other extracurricular activities.
            Students can check into events and meetings to earn points which can be redeemed for rewards such as priority arena scheduling!
            Our system was also designed with faculty members in mind.
            Faculty members can easily manage clubs, and administrators can setup events in seconds!
          </span>
        </div>
      </section>

      <section className="flex flex-col items-center justify-center">
        <h2
          className="text-blue-950 text-center text-5xl font-extrabold uppercase max-md:text-4xl"
        >Student Example
        </h2>
        <div className="flex flex-row gap-10 mt-10 max-md:!flex-col items-center justify-center">
          <img
            loading="lazy"
            srcSet={process.env.PUBLIC_URL + "/assets/images/events-example.png"}
            alt="Events Page Mobile App"
            className="max-w-[300px] max-md:max-w-full"
          />
          <img
            loading="lazy"
            srcSet={process.env.PUBLIC_URL + "/assets/images/event-example.png"}
            alt="Event Page Mobile App"
            className="max-w-[300px] max-md:max-w-full"
          />
          <img
            loading="lazy"
            srcSet={process.env.PUBLIC_URL + "/assets/images/clubs-example.png"}
            alt="Clubs Page Mobile App"
            className="max-w-[300px] max-md:max-w-full"
          />
        </div>
        {/* <h2
          className="text-blue-950 text-center text-5xl font-extrabold uppercase max-md:text-4xl"
        >Faculty Example
        </h2>
        <div className="flex flex-col gap-10 mt-10 max-md:!flex-col items-center justify-center">
          <img
            loading="lazy"
            srcSet={process.env.PUBLIC_URL + "/assets/images/users-example.png"}
            alt="Users Page Website"
            className="max-w-[300px] max-md:max-w-full"
          />
        </div> */}
      </section>
    </div>

  );
}

export default HomePage;
