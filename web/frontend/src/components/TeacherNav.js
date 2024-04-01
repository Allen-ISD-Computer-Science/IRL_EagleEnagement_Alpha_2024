import * as React from "react";

import { List, ListItemButton, ListItemIcon, ListItemText } from "@mui/material"

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faBars, faPlus, faSliders, faUsers } from '@fortawesome/free-solid-svg-icons'

function TeacherNav(props) {
  const [isHidden, setIsHidden] = React.useState(true);
  const [isAdmin, setIsAdmin] = React.useState(false);

  React.useEffect(() => {
    function setAdmin() {
      setIsAdmin(window.sessionStorage.getItem("isAdmin") === "true");
    }

    if (window.sessionStorage.getItem("isAdmin") === null) {
      fetch(`${process.env.PUBLIC_URL}/isAdmin`, {
        method: "GET",
        headers: {
          Accept: "application/json"
        }
      }).then(res => res.json()).then(json => {
        window.sessionStorage.setItem("isAdmin", json.value);
      }).catch(err => console.error(err));
    } else setAdmin();
  }, []);

  return (
    <div>
      <button
        onClick={() => setIsHidden(!isHidden)}
        className="absolute bg-blue-900 py-2 px-3 rounded-2xl hover:bg-blue-800 top-2 right-2 z-50 text-white hidden max-md:block"
      >
        <FontAwesomeIcon icon={faBars} size="2xl" />
      </button>
      <nav className={`h-full items-stretch bg-blue-950 flex max-w-[400px] z-40 w-full flex-col pb-4 ${isHidden ? "max-md:hidden" : "max-md:sticky"} max-md:w-[100vw] max-md:absolute max-md:max-w-full`}>
        <div className="w-full min-w-[325px]">
          <img
            srcSet={process.env.PUBLIC_URL + "/assets/images/logo.svg"}
            alt="ConnectEdu Logo"
            style={{ width: "100%", height: "150px", aspectRatio: "2/1", padding: "0.5rem", background: "rgba(0,0,0,0.1)" }}
            className="shadow"
          />
        </div>
        <List className="[&_a]:mb-4 [&_span]:text-2xl [&_span]:text-center [&_*]:!text-white [&_*]:!font-semibold">
          <ListItemButton component="a" href={process.env.PUBLIC_URL + "/dashboard"} selected={props.selected === "clubs"}>
            <ListItemIcon className="flex-col items-center">
              <FontAwesomeIcon icon={faUsers} size="2xl" />
            </ListItemIcon>
            <ListItemText primary="Clubs" />
          </ListItemButton>

          <ListItemButton component="a" href={process.env.PUBLIC_URL + "/event-request"} selected={props.selected === "event-request"}>
            <ListItemIcon className="flex-col items-center">
              <FontAwesomeIcon icon={faPlus} size="2xl" />
            </ListItemIcon>
            <ListItemText primary="Event Request" />
          </ListItemButton>
        </List>
        {isAdmin ?
          <List className="!mt-auto [&_a]:mb-4 [&_span]:text-2xl [&_span]:text-center [&_*]:!text-white [&_*]:!font-semibold">
            <ListItemButton component="a" href={process.env.PUBLIC_URL + "/admin/users"}>
              <ListItemIcon className="flex-col items-center">
                <FontAwesomeIcon icon={faSliders} size="2xl" />
              </ListItemIcon>
              <ListItemText primary="Admin" />
            </ListItemButton>
          </List>
          : null
        }
      </nav>
    </div>
  );
}

export default TeacherNav;
