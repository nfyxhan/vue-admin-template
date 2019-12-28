import request from '@/utils/request'

export function login(data) {
  const Base64 = require('js-base64').Base64
  const basic = Base64.encode(data.username + ':' + data.password)
  return request({
    url: '/login',
    method: 'post',
    headers: { 'Authorization': 'Basic ' + basic }
  })
}

export function getInfo(token) {
//  return request({
//    url: '/user/info',
//    method: 'get',
//    params: { token }
//  })
  return new Promise(function(resolve, reject) {
    const r = {
      'ok': true,
      'code': 20000,
      'data': {
        'id': 1,
        'username': 'admin',
        'avatar': '/static/avatar.png'
      }
    }
    resolve(r)
  })
}

export function logout() {
  return new Promise(function(resolve, reject) {
    resolve('Success!')
  })
  // return request({
  //   url: '/user/logout',
  //   method: 'post'
  // })
}
