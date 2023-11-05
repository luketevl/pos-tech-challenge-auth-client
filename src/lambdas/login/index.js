exports.handler = async (event, context) => {
  console.log('Received event', event)
  console.log('Context', context)

  try{

    return {
      status: 200,
      body: JSON.stringify({}),
      headers: {
        'Content-Type': 'application/json'
      }
    }

  }catch(error){
    console.error(error)
    throw new Error(error)
  }
}