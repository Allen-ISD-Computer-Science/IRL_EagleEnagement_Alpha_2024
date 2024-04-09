import * as React from 'react';

import { Button, Modal } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCheck } from '@fortawesome/free-solid-svg-icons';

export default function ApproveEventRequestModal(props) {
    const [open, setOpen] = [props.open, props.setOpen];

    return (
        <Modal open={open} onClose={() => setOpen(false)}>
            <div className='absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white p-4 rounded min-w-[400px] max-w-full shadow'>
                <h2 className='text-2xl font-bold text-center'>
                    <FontAwesomeIcon icon={faCheck} /> Accept {props.name}?
                </h2>
                <br />

                <hr />

                <div className='p-2'></div>

                <p className='text-center'>Select the correct option below depending if you need to create a location and an event for this request or just an event.</p>

                <div className='p-4'></div>

                <h3 className='text-xl font-bold'>Request:</h3>
                <p><span className='font-bold'>Description: </span>{props.selectedRequest?.description || "No description provided."}</p>
                <p><span className='font-bold'>Location: </span>{props.selectedRequest?.location || "No location provided."}</p>
                <p><span className='font-bold'>Date: </span>{props.selectedRequest?.startDate || "No date provided."}</p>

                <div className='p-2'></div>

                <div className='flex flex-row justify-center align-center gap-4'>
                    {/* Cancel button */}
                    <Button
                        variant="outlined"
                        color="error"
                        onClick={() => { if (props.setOpen) props.setOpen(false) }}
                    >
                        Cancel
                    </Button>

                    {/* Both button */}
                    <Button
                        className='text-center'
                        variant="contained"
                        color="secondary"
                        component="a"
                        onClick={() => {
                            if (props.setOpen) props.setOpen(false);
                            window.location.href = `${process.env.PUBLIC_URL}/admin/locations/new?request=${props.selectedRequest?.id}`;
                        }}
                    >
                        Location & Event
                    </Button>

                    {/* Both button */}
                    <Button
                        variant="contained"
                        color="primary"
                        component="a"
                        onClick={() => {
                            if (props.setOpen) props.setOpen(false);
                            window.location.href = `${process.env.PUBLIC_URL}/admin/events/new?request=${props.selectedRequest?.id}`;
                        }}
                    >
                        Event
                    </Button>
                </div>
            </div>
        </Modal>
    );
}