exports.handler = async (event) => {
  try{
    const newEvent = {
      ...event,
      response: {
        ...event.response,
        autoConfirmUser: true,
        autoVerifyEmail: true,
        autoVerifyPhone: true
      }
    }
   return newEvent
  } catch(error){
      console.error(error)
      return event
  }
}