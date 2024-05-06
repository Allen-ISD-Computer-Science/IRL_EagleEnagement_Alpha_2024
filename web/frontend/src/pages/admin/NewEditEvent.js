import * as React from "react";
import dayjs from "dayjs";

import { DateTimePicker, TimePicker } from "@mui/x-date-pickers";
import { ToastContainer, toast } from 'react-toastify';

import AdminNav from "../../components/AdminNav";
import LoadingOverlay from "../../components/LoadingOverlay";
import EventRequestCard from "../../components/EventRequestCard";
import { Autocomplete, Button, MenuItem, Select, TextField } from "@mui/material";

function NewEditEventPage(props) {
  const [title, setTitle] = React.useState("New Event");

  const [eventInfo, setEventInfo] = React.useState({
    // name: "B.E.S.T. Robotics State Competition", description: "Come visit for the B.E.S.T. Robotics Competition!", eventType: "Robotics", locationName: "Allen Stadium", locationID: 0, startDate: "9/1/2021", pointsWorth: 3, checkinType: "manual"
  });

  const [eventTypes, setEventTypes] = React.useState([
    "Football", "Soccer", "Robotics"
  ]);

  const [locations, setLocations] = React.useState([
    // { id: 1, name: "AHS PAC" }
  ]);

  const [eventRequest, setEventRequest] = React.useState(null
    // { name: "hi", description: "cool event"}
  );

  const [requests, setRequests] = React.useState(0);

  React.useEffect(() => {
    const getEventTypes = async () => {
      const res = await fetch(`${process.env.PUBLIC_URL}/admin/api/eventTypes`, { headers: { Accept: "application/json" }, method: "POST" });
      return await res.json();
    }

    const getLocations = async () => {
      const res = await fetch(`${process.env.PUBLIC_URL}/admin/api/locations`, { headers: { Accept: "application/json", "Content-Type": "application/json" }, method: "POST", body: JSON.stringify({}) });
      return await res.json();
    }

    setRequests((prev) => prev + 1);
    getLocations().then((locations) => {
      setLocations(locations.sort((a, b) => a.name.toUpperCase() - b.name.toUpperCase()));
      setRequests((prev) => prev - 1);
    }).catch((err) => {
      setRequests((prev) => prev - 1);
    })

    setRequests((prev) => prev + 1);
    getEventTypes().then((types) => {
      setEventTypes(types);
      setRequests((prev) => prev - 1);
    }).catch((err) => {
      setRequests((prev) => prev - 1);
    })

    const eventID = parseInt(window.location.pathname.split("/").pop());
    if (!isNaN(eventID)) {
      setTitle("Edit Event - ...");

      const getEvent = async () => {
        const res = await fetch(`${process.env.PUBLIC_URL}/admin/api/event/${eventID}`, { headers: { Accept: "application/json" }, method: "POST" });
        return await res.json();
      }

      setRequests((prev) => prev + 1);
      getEvent().then((ev) => {
        console.log(ev);
        const event = ev;
        event.startDate = dayjs(ev.startDate);
        event.endDate = dayjs(ev.endDate);
        console.log(event);
        document.title = "Edit Event - " + event.name;
        setTitle("Edit Event - " + event.name);
        setEventInfo(event);
        setRequests((prev) => prev - 1);
      }).catch((err) => {
        setRequests((prev) => prev - 1);
        // console.error(err);
      });

      return;
    }

    if (!window.location.pathname.endsWith("/admin/events/new")) throw new Error("Invalid event ID.");
    setEventInfo({
      name: "",
      description: "",
      eventType: "",
      locationName: "",
      locationID: -1,
      checkinType: "",
      pointsWorth: -1,
      startDate: "",
      endDate: ""
    });

    const urlParams = new URLSearchParams(window.location.search);
    const requestID = urlParams.get("request");
    if (requestID) {
      const getRequest = async () => {
        const res = await fetch(`${process.env.PUBLIC_URL}/admin/api/eventRequest/${requestID}`, { headers: { Accept: "application/json" }, method: "POST" });
        return await res.json();
      }

      setRequests((prev) => prev + 1);
      getRequest().then((req) => {
        setEventRequest({
          ...req,
          id: requestID
        });
        setRequests((prev) => prev - 1);
      }).catch((err) => {
        setRequests((prev) => prev - 1);
      });
    }
  }, []);

  const saveButtonClicked = async () => {
    var isNew = true;
    var urlPath = "/admin/api/events/new"
    if (!window.location.pathname.endsWith("/admin/events/new")) {
      isNew = false;
      const eventID = parseInt(window.location.pathname.split("/").pop());
      urlPath = `/admin/api/event/${eventID}/edit`
    }

    const filteredInfo = Object.assign({}, eventInfo);
    delete filteredInfo.locationName;
    if (!filteredInfo.customImagePath) delete filteredInfo.customImagePath;

    const keys = Object.keys(filteredInfo);
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];
      if ((filteredInfo[key] === "" || filteredInfo[key] === null || filteredInfo[key] === -1) && (key !== "customImagePath")) {
        toast.error(`${key} cannot be empty!`);
        return;
      }
    }

    console.log(filteredInfo.startDate.toISOString());
    console.log(filteredInfo.endDate.toISOString());

    filteredInfo.startDate = filteredInfo.startDate.toISOString().split('.')[0] + "Z";
    filteredInfo.endDate = filteredInfo.startDate.split('T')[0] + "T" + filteredInfo.endDate.toISOString().split("T")[1].split(".")[0] + "Z";

    if (requests > 0) {
      toast.error(`Request already made. Please wait!`);
      return;
    }

    setRequests((prev) => prev + 1);
    try {
      const res = await fetch(`${process.env.PUBLIC_URL}${urlPath}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: JSON.stringify(filteredInfo)
      });

      setRequests((prev) => prev - 1);

      if (res.status === 200) {
        toast.success(`${isNew ? "Created" : "Updated"} event!`);

        if (isNew && eventRequest) {
          setRequests((prev) => prev + 1);
          try {
            const deleteRes = await fetch(`${process.env.PUBLIC_URL}/admin/api/eventRequest/${eventRequest.id}/delete`, {
              headers: {
                Accept: "application/json",
              }, method: "POST"
            });

            const result = await deleteRes.json();
            setRequests((prev) => prev - 1);

            if (result.success) {
              toast.success(`Removed event request!`);
            } else {
              toast.error(result.message);
            }
          } catch (e) {
            toast.error("Error removing event request!");
          }
        }
      } else {
        toast.error(res.statusText);
      }
    } catch (e) {
      console.error(e);
      setRequests((prev) => prev - 1);
    }
  }

  return (
    <div className="flex flex-row items-stretch min-h-[100vh]">
      <AdminNav selected="events" />
      <div className="flex flex-col items-stretch w-full">
        <LoadingOverlay
          isActive={requests !== 0}
          text='Loading...'
        />

        <div className="flex flex-col justify-center text-white text-5xl font-bold bg-blue-950 w-full pl-12 pr-12 items-start max-md:text-4xl max-md:px-5 h-[150px] max-md:max-h-[100px]">
          <span className="my-auto">
            {title}
          </span>
        </div>
        <div className="flex flex-row justify-center align-center max-md:!flex-col-reverse">
          {/* Start a form, split it into two columns */}
          <form className="flex flex-row flex-1 relative justify-between items-stretch p-10 gap-10 max-md:flex-col max-md:gap-4 max-md:p-4">
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

            {/* Left column */}
            <div className="flex-1">
              <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="name">
                Event Name
              </label>
              <TextField
                className="border bg-gray-100 rounded-xl w-full"
                placeholder="Event Name"
                name="name"
                value={eventInfo?.name}
                onChange={(e) => {
                  setEventInfo({
                    ...eventInfo,
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
                value={eventInfo?.eventType}
                onChange={(e) => {
                  setEventInfo({
                    ...eventInfo,
                    eventType: eventTypes[e.target.value]
                  });
                }}
                onBlur={(e) => {
                  if (eventInfo.eventType !== e.target.value) {
                    setEventInfo({
                      ...eventInfo,
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
                  multiline={true}
                  maxLength={255}
                  value={eventInfo?.description}
                  onChange={(e) => {
                    setEventInfo({
                      ...eventInfo,
                      description: e.currentTarget.value
                    })
                    // TODO: add #/255
                  }}
                />
              </div>

              <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="location">
                Event Location
              </label>
              <Select
                className="border bg-gray-100 rounded-xl w-full"
                name="location"
                value={eventInfo?.locationID}
                onChange={(e, val) => {
                  setEventInfo({
                    ...eventInfo,
                    locationName: val.props.children,
                    locationID: parseInt(e.target.value)
                  })
                }}
              >
                {
                  locations?.map(loc => <MenuItem value={loc.id}>{loc.name}</MenuItem>)
                }
              </Select>

              <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="checkInType">
                Check-In Type
              </label>
              <Select
                className="border bg-gray-100 rounded-xl w-full"
                name="checkInType"
                value={eventInfo?.checkinType}
                onChange={(e) => {
                  setEventInfo({
                    ...eventInfo,
                    checkinType: e.target.value
                  })
                }}
              >
                <MenuItem value="location">Location</MenuItem>
                <MenuItem value="manual">Manual</MenuItem>
                <MenuItem value="photo">Photo</MenuItem>
              </Select>

              <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="points">
                Points
              </label>
              <TextField
                className="border bg-gray-100 rounded-xl w-full"
                placeholder="Points"
                type="number"
                name="points"
                value={eventInfo.pointsWorth === -1 ? "" : eventInfo.pointsWorth}
                onChange={(e) => {
                  setEventInfo({
                    ...eventInfo,
                    pointsWorth: parseInt(e.currentTarget.value)
                  })
                }}
              />
            </div>

            {/* Right column */}
            <div className="flex-1">
              <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="startDate">
                Start Date & Time
              </label>
              <DateTimePicker
                className="border bg-gray-100 rounded-xl w-full"
                value={dayjs(eventInfo.startDate)}
                onChange={(newValue) => {
                  setEventInfo({
                    ...eventInfo,
                    startDate: newValue
                  })
                }}
              />

              <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="endTime">
                End Time
              </label>
              <TimePicker
                className="border bg-gray-100 rounded-xl w-full"
                value={dayjs(eventInfo.endDate)}
                onChange={(newValue) => {
                  setEventInfo({
                    ...eventInfo,
                    endDate: newValue
                  })
                }}
              />

              <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="image">
                Event Image (Optional)
              </label>
              <Button
                variant="contained"
                component="label"
              >
                Upload File
                <input
                  type="file"
                  hidden
                />
              </Button>

              <br />

              <div
                className="flex flex-row-reverse items-end gap-4 mt-4 w-full mt-20"
              >
                {/* Submit button */}
                <Button
                  variant="contained"
                  color="success"
                  onClick={() => { saveButtonClicked(); }}
                >
                  Save
                </Button>

                {/* Cancel button */}
                <Button
                  variant="contained"
                  color="error"
                  component="a"
                  href={eventRequest === null ? process.env.PUBLIC_URL + "/admin/events" : process.env.PUBLIC_URL + "/admin/event-requests"}
                >
                  Cancel
                </Button>
              </div>
            </div>
          </form>
          {
            eventRequest !== null ?
              <div className="max-w-[35%] flex flex-row justify-center align-center gap-4 p-4 max-md:max-w-full">
                <EventRequestCard
                  request={eventRequest}
                />
              </div>
            : null
          }
        </div>
      </div>
    </div>
  );
}

export default NewEditEventPage;
