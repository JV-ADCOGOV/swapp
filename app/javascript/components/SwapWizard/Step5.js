import React from 'react'
import Button from './Button'
import ButtonOutline from './ButtonOutline'
import dayjs from 'dayjs'

export const Step5 = (props) => {
  return (
    <>
      <h3 className="font-semibold tracking-wide">Review</h3>
      <div className="mt-4">
        <div className="flex gap-10">
          <div className="flex flex-col">
            <div>Check-In</div>
            <div>{dayjs(props.checkIn).format('ddd MM/DD/YYYY')}</div>
          </div>
          <div className="flex flex-col">
            <div>Check-Out</div>
            <div>{dayjs(props.checkOut).format('ddd MM/DD/YYYY')}</div>
          </div>
        </div>
      </div>
      <div className="mt-6"> Intake Dates</div>
      <ul>
        {props.intakeDates.map((date, idx) => (
          <li key={idx}>{dayjs(props.date).format('ddd MM/DD/YYYY')}</li>
        ))}
      </ul>
      <div className="mt-6 flex justify-between">
        <ButtonOutline onClick={props.back}>
          Back: I want to make changes
        </ButtonOutline>
        <Button type="submit">Looks good, let's go! </Button>
      </div>
    </>
  )
}
