import React from 'react'

const UserRow = (props) => {
  return (
    <tr>
      <td className="px-6 py-4 whitespace-nowrap">
        <div className="flex items-center">
          <div className="flex-shrink-0 h-10 w-10">
            <span className="mt-1 inline-flex items-center justify-center h-10 w-10 rounded-full bg-gray-500">
              <span className="text-sm md:text-base font-medium leading-none text-white">
                {`${props.person.first_name[0]}${props.person.last_name[0]}`}
              </span>
            </span>
          </div>
          <div className="ml-4">
            <div className="">
              <span className="text-sm font-semibold text-gray-900">
                {`${props.person.first_name} ${props.person.last_name}`}
              </span>
              {!props.person.active && (
                <span className="ml-2 px-2 rounded text-xs tracking-wide uppercase bg-red-100 text-gray-800">
                  Deactivated
                </span>
              )}
            </div>
            <div className="text-sm text-gray-500">{props.person.email}</div>
          </div>
        </div>
      </td>
      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 space-x-2">
        {props.person.roles.map((role, roleIdx) => {
          return (
            <span
              key={roleIdx}
              className="px-2 py-1 bg-indigo-50 text-black text-sm rounded"
            >
              {role}
            </span>
          )
        })}
      </td>
      <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
        <button
          type="button"
          className="px-2 py-1 bg-admin-blue hover:bg-admin-blue-darker text-black text-sm rounded border border-black"
          onClick={() => props.onEdit(props.person.id)}
        >
          Edit
        </button>
      </td>
    </tr>
  )
}

export default UserRow
