import request from '@/utils/request'

export function publish(data) {
  return request({
    url: '/publish',
    method: 'post',
    data
  })
}

export function getLastImage(data) {
  const size = data.size || 4
  const wait = data.wait || false
  const cap = data.cap || false
  return request({
    url: '/image/last?size=' + size + '&wait=' + wait + '&cap=' + cap,
    method: 'get'
  })
}

