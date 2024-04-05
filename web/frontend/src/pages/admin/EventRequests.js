import * as React from "react";

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faAdd, faSearch, faTrash } from '@fortawesome/free-solid-svg-icons'

import { ToastContainer, toast } from 'react-toastify';

import AdminNav from "../../components/AdminNav";
import LoadingOverlay from "../../components/LoadingOverlay";

import DeleteModal from "../../components/DeleteModal";

function EventRequestsPage(props) {
  const [requests, setRequests] = React.useState(0);

  const [eventRequests, setEventRequests] = React.useState([
    { id: 0, name: "hi" }
  ]);

  const [selectedRequest, setSelectedRequest] = React.useState(null);
  const [openModal, setOpenModal] = React.useState(null);
  const [updateCount, setUpdateCount] = React.useState(0);

  const deleteRequestModal = (id) => {
    setSelectedRequest(eventRequests.find(a => a.id === id));
    setOpenModal("delete");
  }

  React.useEffect(() => {
    console.log(updateCount);
    const getRequests = async () => {
      setRequests((prev) => prev + 1);

      const res = await fetch(`${process.env.PUBLIC_URL}/admin/api/eventRequests`, {
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json"
        }, method: "POST", body: JSON.stringify({})
      });

      return await res.json();
    }

    getRequests().then((reqs) => {
      setEventRequests(reqs);
      setRequests((prev) => prev - 1);
    }).catch((err) => {
      setRequests((prev) => prev - 1);
      console.error(err);
    });
  }, [setEventRequests, setRequests, updateCount])

  return (
    <div className="flex flex-row items-stretch min-h-[100vh]">
      <AdminNav selected="event-requests" />
      <div className="flex flex-col items-stretch w-full">
        <LoadingOverlay
          isActive={requests !== 0}
          text='Loading your content...'
        />
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
        <DeleteModal
          open={openModal === "delete"}
          setOpen={(val) => setOpenModal(val ? "delete" : null)}
          name={selectedRequest ? `Event Request: '${selectedRequest.name}'` : "?"}
          onConfirmDeletion={async () => {
            setRequests((prev) => prev + 1);

            try {
              const res = await fetch(`${process.env.PUBLIC_URL}/admin/api/eventRequest/${selectedRequest.id}/delete`, {
                headers: {
                  Accept: "application/json",
                }, method: "POST"
              });
        
              const result = await res.json();
              setRequests((prev) => prev - 1);

              if (result.success) {
                setUpdateCount((prev) => prev + 1);
                toast.success(`Removed the '${selectedRequest.name}' Event Request.`)
              } else {
                toast.error(`Error removing the '${selectedRequest.name}' Event Request... ${result.msg}`)
              }
            } catch(err) {
              console.error(err);
              setRequests((prev) => prev - 1);
              toast.error(`Error removing the '${selectedRequest.name}' Event Request.`)
            }
          }}
        />

        <div className="flex flex-col justify-center text-white text-5xl font-bold bg-blue-950 w-full pl-12 pr-12 items-start max-md:text-4xl max-md:px-5 h-[150px] max-md:max-h-[100px]">
          <span className="my-auto">
            Event Requests
          </span>
        </div>
        <div
          id="searchBox"
          className="flex flex-row justify-start items-stretch pl-16 pt-8 gap-4 w-1/2 [&>*]:self-stretch max-md:w-full max-md:flex-col max-md:gap-2 max-md:p-4"
        >
          <input
            type="text"
            className="border bg-gray-100 border-slate-600 rounded-xl p-2 w-full"
            placeholder="Search"
          />
          <button
            className="bg-blue-950 text-white px-4 py-2 rounded-xl"
          >
            <FontAwesomeIcon icon={faSearch} size="xl" />
          </button>
        </div>
        <div
          className="pt-8 px-16 w-full max-md:pt-4 max-md:px-4">
          <table
            className="w-full bg-blue-900 text-white table-fixed text-center border border-slate-400 [&_th]:border-slate-400 [&_td]:border-slate-400 [&_th]:border-r [&_td]:border-r [&_th]:p-2 [&_td]:p-2"
          >
            <thead className="border-b border-slate-400">
              {/* date, number of students, and actions columns */}
              <tr className="text-xl font-bold">
                <th>Event Name</th>
                <th>Date</th>
                <th>User Requested</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody className="border-b border-slate-400">
              {/* meeting logs */}
              {
                eventRequests?.map((eventReq, i) =>
                  <tr key={i} className="text-l">
                    <td>{eventReq.name}</td>
                    <td>{eventReq.startDate}</td>
                    <td>{eventReq.userRequested}</td>
                    <td className="[&_button]:mx-4">
                      <button className="bg-blue-950 text-white px-4 py-2 rounded-xl"><FontAwesomeIcon icon={faAdd} size="lg" /></button>
                      <button onClick={() => deleteRequestModal(eventReq.id)} className="bg-blue-950 text-white px-4 py-2 rounded-xl"><FontAwesomeIcon icon={faTrash} size="lg" /></button>
                    </td>
                  </tr>
                )
              }
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

export default EventRequestsPage;
