import * as React from 'react';

import { Button, Modal } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faWarning } from '@fortawesome/free-solid-svg-icons';

export default function DeleteModal(props) {
    const [open, setOpen] = [props.open, props.setOpen];

    return (
        <Modal open={open} onClose={() => setOpen(false)}>
            <div className='absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white p-4 rounded min-w-[400px] max-w-full shadow'>
                <h2 className='text-2xl font-bold text-center'>
                    <FontAwesomeIcon icon={faWarning} /> Permanently Delete {props.name}?
                </h2>
                <br />

                <hr />

                <div className='p-2'></div>

                <p>Are you sure you want to permanently delete {props.name}? This action cannot be undone.</p>

                <div className='p-2'></div>

                <div className='flex flex-row justify-center align-center gap-4'>
                    {/* Submit button */}
                    <Button
                        variant="contained"
                        color="primary"
                        onClick={() => { if (props.setOpen) props.setOpen(false) }}
                    >
                        Cancel
                    </Button>

                    {/* Cancel button */}
                    <Button
                        variant="contained"
                        color="error"
                        component="a"
                        onClick={() => {
                            if (props.setOpen) props.setOpen(false)
                            if (props.onConfirmDeletion) props.onConfirmDeletion();
                        }}
                    >
                        Delete
                    </Button>
                </div>
            </div>
        </Modal>
    );
}