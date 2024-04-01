import * as React from "react";

import { Button, TextField } from "@mui/material";
import { ToastContainer, toast } from 'react-toastify';

import AdminNav from "../../components/AdminNav";
import MapSelector from "../../components/MapSelector";
import LoadingOverlay from "../../components/LoadingOverlay";

function NewEditLocationPage(props) {
  const [title, setTitle] = React.useState("New Location");

  const [locationInfo, setLocationInfo] = React.useState({
    locationName: "Allen High School PAC", address: "300...", latitude: 33.1, longitude: -96.6, radius: 100
  });

  const [requests, setRequests] = React.useState(0);

  React.useEffect(() => {
    const locationID = parseInt(window.location.pathname.split("/").pop());
    if (!isNaN(locationID)) {
      setTitle("Edit Location - ...");

      const getLocation = async () => {
        const res = await fetch(`${process.env.PUBLIC_URL}/admin/api/location/${locationID}`, { headers: { Accept: "application/json" }, method: "POST" });
        return await res.json();
      }

      setRequests((prev) => prev + 1);
      getLocation().then((location) => {
        setRequests((prev) => prev - 1);
        document.title = "Edit Location - " + location.locationName;
        setTitle("Edit Location - " + location.locationName);
        setLocationInfo(location);
      }).catch((err) => {
        setRequests((prev) => prev - 1);
        // console.error(err);
      });

      return;
    }

    if (!window.location.pathname.endsWith("/admin/locations/new")) throw new Error("Invalid location ID.");
    setLocationInfo({
      locationName: "",
      address: "",
      description: "",
      latitude: -1,
      longitude: -1,
      radius: 100
    });
  }, []);

  const saveButtonClicked = async () => {
    var isNew = true;
    var urlPath = "/admin/api/locations/new"
    if (!window.location.pathname.endsWith("/admin/locations/new")) {
      isNew = false;
      const eventID = parseInt(window.location.pathname.split("/").pop());
      urlPath = `/admin/api/location/${eventID}/edit`
    }

    const filteredInfo = Object.assign({}, locationInfo);
    delete filteredInfo.id;
    filteredInfo.latitude = parseFloat(filteredInfo.latitude);
    filteredInfo.longitude = parseFloat(filteredInfo.longitude);
    filteredInfo.radius = parseInt(filteredInfo.radius);

    const keys = Object.keys(filteredInfo);
    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];
      if (filteredInfo[key] === "" || filteredInfo[key] === null || filteredInfo[key] === -1) {
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

    if (requests > 0) {
      toast.error(`Request already made. Please wait!`, {
        position: "top-right",
        autoClose: 2000,
        closeOnClick: true,
        pauseOnHover: true,
        theme: "light"
      });
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
        toast.success(`${isNew ? "Created" : "Updated"} location!`, {
          position: "top-right",
          autoClose: 2000,
          closeOnClick: true,
          pauseOnHover: true,
          theme: "light"
        });
      } else {
        const json = await res.json();
        var errorText = res.statusText || json.reason;
        if (errorText.includes("Duplicate")) errorText = "Name already exists!";

        toast.error(errorText, {
          position: "top-right",
          autoClose: 2000,
          closeOnClick: true,
          pauseOnHover: true,
          theme: "light"
        });
      }
    } catch (e) {
      console.error(e);
      setRequests((prev) => prev - 1);
    }
  }

  const updateMapValues = (latlng, radius) => {
    setLocationInfo((locInfo) => {
      return {
        ...locInfo,
        latitude: latlng.lat,
        longitude: latlng.lng,
        radius: radius
      }
    });
  }

  return (
    <div className="flex flex-row items-stretch min-h-[100vh]">
      <AdminNav selected="locations" />
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
        {/* Start a form, split it into two columns */}
        <form className="flex flex-row justify-between items-stretch p-10 gap-10 max-md:flex-col max-md:gap-4 max-md:p-4" onSubmit={(e) => { e.preventDefault(); }}>
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
              Location Name
            </label>
            <TextField
              className="border bg-gray-100 rounded-xl w-full"
              placeholder="Location Name"
              name="name"
              value={locationInfo?.locationName}
              onChange={(e) => {
                setLocationInfo({
                  ...locationInfo,
                  locationName: e.currentTarget.value
                })
              }}

            />

            <label className="block text-gray-700 text-sm font-bold mb-2 mt-4" htmlFor="address">
              Address
            </label>
            <TextField
              className="border bg-gray-100 rounded-xl w-full"
              placeholder="Address"
              name="address"
              value={locationInfo?.address}
              onChange={(e) => {
                setLocationInfo({
                  ...locationInfo,
                  address: e.currentTarget.value
                })
              }}
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
                multiline={true}
                value={locationInfo?.description}
                onChange={(e) => {
                  setLocationInfo({
                    ...locationInfo,
                    description: e.currentTarget.value
                  })
                }}
              />
            </div>
          </div>

          {/* Right column */}
          <div className="flex-1 flex flex-col">
            <label className="block text-gray-700 text-sm font-bold mb-2" htmlFor="map">
              Choose Location
            </label>
            <MapSelector
              lat={locationInfo?.latitude}
              lng={locationInfo?.longitude}
              radius={locationInfo?.radius}
              onChange={updateMapValues}
            />

            <br />

            <div
              className="flex-1 flex flex-row-reverse items-end gap-4 mt-4 w-full mt-20"
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
                href={process.env.PUBLIC_URL + "/admin/locations"}
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

export default NewEditLocationPage;
