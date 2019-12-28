import request from '@/utils/request'

export function getPods(data) {
  return request({
    url: '/k8s/pods',
    method: 'get'
  })
}

