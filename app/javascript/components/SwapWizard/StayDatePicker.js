import React from 'react'
import DayPicker, { DateUtils } from 'react-day-picker'
import 'react-day-picker/lib/style.css'
import './StayDatePicker.css'
import { getDaysArray } from '../utils'
import dayjs from 'dayjs'

export default class StayDatePicker extends React.Component {
  static defaultProps = {
    numberOfMonths: 2,
    canChangeMonth: false,
    showOutsideDays: true,
    enableOutsideDaysClick: false,
  }

  constructor(props) {
    super(props)
    this.handleDayClick = this.handleDayClick.bind(this)
    this.handleResetClick = this.handleResetClick.bind(this)
    this.state = this.getInitialState()
  }

  getInitialState() {
    const firstCalendarDay = new Date(dayjs().startOf('month'))
    const lastCalendarDay = new Date(
      dayjs()
        .month(new Date().getMonth() + (this.props.numberOfMonths - 1))
        .endOf('month')
    )
    const allCalendarDays = getDaysArray(firstCalendarDay, lastCalendarDay)
    const disabledDays = allCalendarDays.filter((date, idx) => {
      return DateUtils.isPastDay(date) || (this.props.preventEditingFromDate && DateUtils.isDayBefore(date, this.props.originalTo))
    })

    return {
      from: this.props.from,
      to: this.props.to,
      disabledDays,
      preventEditingFromDate: this.props.preventEditingFromDate,
      originalFrom: this.props.originalFrom,
      originalTo: this.props.originalTo
    }
  }

  handleDayClick(day) {
    // byebug
    if (DateUtils.isPastDay(day)) return false
    else if (this.state.preventEditingFromDate && DateUtils.isDayBefore(day, this.state.originalTo)) return false
    else if (this.state.preventEditingFromDate && DateUtils.isSameDay(day, this.state.to)) return false

    const range = DateUtils.addDayToRange(day, this.state)
    this.setState(range)
    this.props.onStayDatesChange(range)
  }

  handleResetClick(event) {
    event.preventDefault()
    const stayDates = { from: this.state.preventEditingFromDate ? this.state.originalFrom : undefined, 
                          to: this.state.preventEditingFromDate ? this.state.originalTo : undefined }
    this.setState(stayDates)
    this.props.onStayDatesChange(stayDates)
  }

  render() {
    const { from, to } = this.state
    const modifiers = { start: from, end: to }

    return (
      <div>
        <DayPicker
          className="StayDayPicker tabular-nums"
          numberOfMonths={this.props.numberOfMonths}
          showOutsideDays={this.props.showOutsideDays}
          canChangeMonth={this.props.canChangeMonth}
          selectedDays={[from, { from, to }]}
          modifiers={modifiers}
          onDayClick={this.handleDayClick}
          disabledDays={this.state.disabledDays}
        />
        <div className="mt-4 text-3xl tabular-nums">
          {!from && !to && (
            <p className="">
              When is <span className="font-bold">check-in?</span>
            </p>
          )}
          {from && !to && (
            <p className="">
              When is <span className="font-bold">check-out?</span>
            </p>
          )}
          {from && to && (
            <div className="flex justify-center items-center gap-8">
              <div>
                <span className="font-bold">Check-in:</span>{' '}
                {from.toLocaleDateString()}
              </div>
              <div>
                <span className="font-bold">Check-out:</span>{' '}
                {to.toLocaleDateString()}
              </div>
              <button className="link" onClick={this.handleResetClick}>
                Reset
              </button>
            </div>
          )}
        </div>
      </div>
    )
  }
}
