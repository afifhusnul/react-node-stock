'use strict'

module.exports.rest = {
  // createResponse: function (code, response, errorCode, errorDescription) {
  //   return {
  //     meta: {
  //       code: code,
  //       errorCode: (typeof errorCode === 'undefined' && code !== 200) ? 'MSA:00000' : errorCode,
  //       errorDescription: errorDescription
  //     },
  //     response: response
  //   };
  // }
  
  // createResponse: (code, response, errorCode, errorDescription) => {
  //   const newResponse = {
  //     meta: {
  //       code: code,
  //       errorDescription: errorDescription
  //     },
  //     response: response
  //   }

  //   if (errorCode) {
  //     newResponse.meta.errorCode = errorCode
  //   }

  //   return newResponse
  // }


  createResponse: (code, response, errorCode, errorDescription, errorTitle) => {
    const newResponse = {
      meta: {
        code: code,
        errorDescription: errorDescription
      },
      response: response
    }

    if (errorCode) {
      newResponse.meta.errorCode = errorCode
      newResponse.meta.errorTitle = errorTitle
    }

    return newResponse
  }

  
}