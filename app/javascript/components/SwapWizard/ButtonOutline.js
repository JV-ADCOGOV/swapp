import React from 'react'

const ButtonOutline = (props) => {
  return (
    <button
      className="px-4 py-2 
      rounded-lg border border-gray-700 hover:bg-grey-50 text-gray-900 text-xl"
      type="button"
      onClick={props.onClick}
      {...props}
    >
      {props.children}
    </button>
  )
}

export default ButtonOutline
