import * as React from 'react';

function EventRequestCard(props) {
    return (
        <div
          className="shadow-sm bg-neutral-200 self-center flex max-w-full flex-col justify-center items-stretch mt-16 pl-6 pr-10 py-6 rounded-xl m-10 max-md:mt-10 max-md:px-5 max-md:py-4 cursor-pointer">
          <div className="justify-between py-4 max-md:max-w-full">
              <div className="flex flex-col items-stretch w-[74%] ml-5 max-md:w-full max-md:ml-0">
                  <span className="justify-between items-stretch flex flex-col my-auto max-md:max-w-full">
                      <div className="text-black text-3xl font-bold max-md:max-w-full mb-4">
			  {props.request?.name}
                      </div>
                      <div className="text-black text-2xl max-md:max-w-full">
			  <span className="font-bold">Description: </span>{props.request?.description}
                      </div>
		      <div className="text-black text-xl max-md:max-w-full">
			  <span className="font-bold">Event Type: </span>{props.request?.eventType}
		      </div>
		      <div className="text-black text-xl max-md:max-w-full">
			  <span className="font-bold">Event Location: </span>{props.request?.location}
                      </div>
		      <div className="text-black text-xl max-md:max-w-full">
			  <span className="font-bold">Start Date: </span>{props.request?.startDate}
		      </div>
		      <div className="text-black text-xl max-md:max-w-full">
			  <span className="font-bold">End Date: </span>{props.request?.endDate}
                      </div>
                  </span>
            </div>
          </div>
        </div>
    )
}

export default EventRequestCard;
