import * as React from "react";
import dayjs from "dayjs";

import { DateTimePicker, TimePicker } from "@mui/x-date-pickers";
import { ToastContainer, toast } from 'react-toastify';

import TeacherNav from "../../components/TeacherNav";
import { Button, MenuItem, Select, TextField, Autocomplete } from "@mui/material";

function EventRequestPage(props) {
  const [requestInfo, setRequestInfo] = React.useState({});
  const [isDisabled, setDisabled] = React.useState(false);
  const [eventTypes, setEventTypes] = React.useState([]);

  const submitRequest = async () => {
    const urlPath = `${process.env.PUBLIC_URL}/faculty/api/requestEvent`

    const filteredInfo = Object.assign({}, requestInfo);

    const keys = ["name", "eventType", "description", "location", "startDate", "endDate"];
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];
      if ((filteredInfo[key] === "" || filteredInfo[key] === null || filteredInfo[key] === -1)) {
        toast.error(`${key} cannot be empty!`, {
          position: "top-right",
          autoClose: 2000,
          closeOnClick: true,
          pauseOnHover: true,
          theme: "light"
        });
        return;
      }
    }

    console.log(filteredInfo.startDate.toISOString());
    console.log(filteredInfo.endDate.toISOString());

    filteredInfo.startDate = filteredInfo.startDate.toISOString().split('.')[0] + "Z";
    filteredInfo.endDate = filteredInfo.startDate.split('T')[0] + "T" + filteredInfo.endDate.toISOString().split("T")[1].split(".")[0] + "Z";

    try {
      setDisabled(true);
      const res = await fetch(urlPath, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: JSON.stringify(filteredInfo)
      });

      if (res.status === 200) {
        toast.success(`Requested event!`, {
          position: "top-right",
          autoClose: 2000,
          closeOnClick: true,
          pauseOnHover: true,
          theme: "light"
        });
      } else {
        toast.error(res.statusText, {
          position: "top-right",
          autoClose: 2000,
          closeOnClick: true,
          pauseOnHover: true,
          theme: "light"
        });
        setDisabled(false);
      }
    } catch (e) {
      console.error(e);
    }
  }

  return (
    <div className="flex flex-row items-stretch min-h-[100vh]">
      <TeacherNav selected="event-request" />
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
      <div className="flex flex-col items-stretch w-full">
        <div className="flex flex-col justify-center text-white text-5xl font-bold bg-blue-950 w-full pl-12 pr-12 items-start max-md:text-4xl max-md:px-5 h-[150px] max-md:max-h-[100px]">
          <span className="my-auto">
            Event Request
          </span>
        </div>
        {/* Start a form, split it into two columns */}
        <form className="flex flex-row justify-between items-stretch p-10 gap-10 max-md:flex-col max-md:gap-4 max-md:p-4">

          {/* Left column */}
          <div className="flex-1">
            <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="name">
              Event Name
            </label>
            <TextField
              className="border bg-gray-100 rounded-xl w-full"
              placeholder="Event Name"
              name="name"
              value={requestInfo?.name}
              onChange={(e) => {
                setRequestInfo({
                  ...requestInfo,
                  name: e.currentTarget.value
                })
              }}

            />

            <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="type">
              Event Type
            </label>
            <Autocomplete
              className="border bg-gray-100 rounded-xl w-full"
              name="type"
              options={eventTypes}
              value={requestInfo?.eventType}
              onChange={(e) => {
                setRequestInfo({
                  ...requestInfo,
                  eventType: eventTypes[e.target.value]
                });
              }}
              onBlur={(e) => {
                if (requestInfo.eventType !== e.target.value) {
                  setRequestInfo({
                    ...requestInfo,
                    eventType: e.target.value
                  });
                }
              }}
              freeSolo
              renderInput={params => <TextField {...params} />}
            />

            <div className="relative">
              <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="description">
                Description
              </label>
              <TextField
                className="border bg-gray-100 rounded-xl w-full"
                placeholder="Description"
                name="description"
                maxLength={255}
                value={requestInfo?.description}
                onChange={(e) => {
                  setRequestInfo({
                    ...requestInfo,
                    description: e.currentTarget.value
                  })
                  // TODO: add #/255
                }}

              />
            </div>

          </div>

          {/* Right column */}
          <div className="flex-1">
            <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="location-description">
              Event Location (include address)
            </label>
            <TextField
              className="border bg-gray-100 rounded-xl w-full"
              placeholder="Location Description"
              name="location-description"
              maxLength={1000}
              value={requestInfo?.location}
              onChange={(e) => {
                setRequestInfo({
                  ...requestInfo,
                  location: e.currentTarget.value
                })
              }}

            />

            <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="startDate">
              Start Date & Time
            </label>
            <DateTimePicker
              className="border bg-gray-100 rounded-xl w-full"
              value={dayjs(requestInfo?.startDate)}
              onChange={(newValue) => {
                setRequestInfo({
                  ...requestInfo,
                  startDate: newValue
                })
              }}
            />

            <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="endTime">
              End Time
            </label>
            <TimePicker
              className="border bg-gray-100 rounded-xl w-full"
              value={dayjs(requestInfo?.endDate)}
              onChange={(newValue) => {
                setRequestInfo({
                  ...requestInfo,
                  endDate: newValue
                })
              }}

            />

            <br />

            <div
              className="flex flex-row-reverse items-end gap-4 mt-4 w-full mt-20"
            >
              {/* Submit button */}
              <Button
                variant="contained"
                color="success"
                onClick={() => submitRequest()}
                disabled={isDisabled}
              >
                Submit
              </Button>

              {/* Cancel button */}
              <Button
                variant="contained"
                color="error"
                component="a"
                href={process.env.PUBLIC_URL + "/dashboard"}
              >
                Cancel
              </Button>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
}

export default EventRequestPage;
