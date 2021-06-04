import React from 'react'
import StayDatePicker from './StayDatePicker'
import Button from './Button'
import ButtonOutline from './ButtonOutline'

export const Step2 = (props) => {
  return (
    <div className="">
      <div className="">
        <h3 className="font-semibold tracking-wide">Set Stay Period</h3>
        <p className="mt-4">
          The <span className="font-semibold italic">stay period</span> is when
          voucher recipients are eligible to actually stay at a hotel.
        </p>
        <p className="">
          It's similar to selecting a check-in and check-out for a hotel
          reservation.
        </p>
      </div>
      <div className="mt-4 text-center">
        <StayDatePicker
          from={props.from}
          to={props.to}
          onStayDatesChange={props.onStayDatesChange}
        />
        <div className="flex justify-between">
          <ButtonOutline onClick={props.back}>Back</ButtonOutline>
          {props.canAdvance && (
            <Button onClick={props.advance}>Next: Set Intake Dates</Button>
          )}
        </div>
      </div>
    </div>
  )
}
