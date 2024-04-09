import * as React from 'react';

function ClubCard(props) {
    return (
        <div
          className="shadow-sm bg-neutral-200 self-center flex max-w-full flex-col justify-center items-stretch mt-16 pl-6 pr-10 py-6 rounded-xl max-md:mt-10 max-md:px-5 m-10 cursor-pointer"
          onClick={() => {
            window.location.href = process.env.PUBLIC_URL + "/club/" + props.clubID;
          }}
        >
          <div className="justify-between py-4 max-md:max-w-full">
            <div className="gap-5 flex max-md:flex-col max-md:items-stretch max-md:gap-0">
              <div className="flex flex-col items-stretch w-[26%] max-md:w-full max-md:ml-0">
                <img
                  loading="lazy"
                  srcSet={process.env.PUBLIC_URL + "/pictures/clubLogos/" + props.clubID}
                  alt={props.clubName + " Logo"}
                  className="aspect-square object-contain object-center w-[185px] overflow-hidden shrink-0 max-w-full rounded-[50%] max-md:mt-10"
                />
              </div>
              <div className="flex flex-col items-stretch w-[74%] ml-5 max-md:w-full max-md:ml-0">
                <span className="justify-between items-stretch flex flex-col my-auto max-md:max-w-full max-md:mt-10">
                <div className="text-black text-3xl font-bold max-md:max-w-full mb-4">
                    {props.clubName}
                  </div>
                  <div className="text-black text-2xl max-md:max-w-full">
                    {props.clubDescription}
                  </div>
                  <span className="justify-between items-stretch flex gap-5 mt-3 max-md:max-w-full max-md:flex-wrap">
                    <div className="text-black text-2xl font-semibold grow shrink basis-auto">
                      {props.clubFollowing + " Students Following"}
                      <br />
                    </div>
                    <div className="text-black text-right text-2xl font-semibold grow shrink basis-auto">
                      {props.clubLastCheckIns + " Check-Ins Last Meeting"}
                      <br />
                    </div>
                  </span>
                </span>
              </div>
            </div>
          </div>
        </div>
    )
}

export default ClubCard;
