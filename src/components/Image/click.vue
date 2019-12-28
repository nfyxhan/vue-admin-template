<!-- from https://github.com/geccomedia/vue-img-color-picker/blob/master/src/ImgColorPicker.vue  -->
<template>
  <div>
    <div style="overflow-y: auto;overflow-x: auto;width: 100%; height: 100%">
      <span> x: {{ x }} y: {{ y }}</span>
      <span> c: {{ status.consumers }} m: {{ status.messages }} u: {{ updateTime }}</span>
      <el-button @click="reload">刷新</el-button>
    </div>
    <div style="overflow-y: auto;overflow-x: auto;width: 100%; height: 100%">
      <el-button @click="down">缩小</el-button>
      <el-button @click="up">放大</el-button>
      <el-button @click="origin">复原</el-button>
      <span> 大小： {{ Math.round(100/size) }}% </span>
      <el-button @click="setMode()">切换模式</el-button>
      <span> 模式： {{ getMode() }} </span>
    </div>
    <div :id="id" style="background-color: gray;overflow-y: auto;overflow-x: auto;width: 100%; height: 100%">
      <!-- <canvas :id="id" :width="width" :height="height" style="background-color: white" @click="onclick" /> -->
    </div>
    <div>
      <el-button @click="push('reboot')">reboot</el-button>
      <el-button @click="push('ie')">ie</el-button>
      <el-button @click="push('reset')">reset</el-button>
      <el-button @click="push('start')">start</el-button>
      <el-button @click="push('shutdown')">shutdown</el-button>
    </div>
  </div>
</template>

<script>
import { publish } from '@/api/publish'
import { getLastImage } from '@/api/publish'
import { formatTime } from '@/utils/index'

export default {
  name: 'ImgClicker',
  props: {
    imagesrc: {
      type: String,
      default: ''
    },
    width: {
      type: Number,
      default: 400
    }
  },
  data() {
    return {
      height: 400,
      canvas: null,
      ctx: null,
      image: null,
      id: null,
      size: 2,
      wait: true,
      cap: false,
      x: 0,
      y: 0,
      status: {
        consumers: 0,
        lastUpdate: 0,
        messages: 0,
        url: ''
      },
      timestamp: 0,
      loaded: false
    }
  },
  computed: {
    updateTime() {
      if (this.timestamp > 0) {
        return formatTime(this.status.lastUpdate)
      }
      return ''
    }
  },
  watch: {
    loaded() {
      if (this.loaded !== true) {
        return
      }
      const div = document.getElementById(this.id)
      this.canvas = document.createElement('canvas')
      this.ctx = this.canvas.getContext('2d')
      this.width = this.canvas.width = this.image.width
      this.height = this.canvas.height = this.image.height // * (this.width / this.image.width)
      this.ctx.drawImage(this.image, 0, 0, this.width, this.height) // draw the image on the canvas
      this.canvas.onclick = this.onclick
      div.innerHTML = ''
      div.appendChild(this.canvas)
      this.x = this.width
      this.y = this.height
    }
  },
  created() {
    this.id = this._uid
    this.reload()
    setInterval(this.reload, 10000)
    setInterval(this.now, 1000)
  },
  methods: {
    onclick(e) {
      const canvasX = e.offsetX
      const canvasY = e.offsetY
      this.x = canvasX
      this.y = canvasY
      this.drawPoint(this.x, this.y)
      publish({
        message: 'click ' + this.x * 10 / this.width + ' ' + this.y * 10 / this.height
      })
    },
    drawPoint(x, y) {
      // const imgData = this.ctx.getImageData(0, 0, this.width, this.height)
      // this.ctx.fillRect(this.x, this.y, 50, 50)
      this.ctx.fillStyle = 'red'
      this.ctx.beginPath()
      this.ctx.moveTo(x, y)
      this.ctx.lineTo(x + 8, y + 20)
      this.ctx.lineTo(x + 3, y + 15)
      this.ctx.lineTo(x + 5, y + 50)
      this.ctx.lineTo(x, y + 40)
      this.ctx.lineTo(x - 5, y + 50)
      this.ctx.lineTo(x - 3, y + 15)
      this.ctx.lineTo(x - 8, y + 20)
      this.ctx.fill()
      // setTimeout(function() {
      //  this.ctx.putImageData(imgData, 0, 0)
      // }, 1000)
    },
    push(message) {
      publish({
        message: message
      })
    },
    reload() {
      getLastImage({ size: this.size, wait: this.wait, cap: this.cap }).then(response => {
        this.status = response.data
        const src = this.status.url
        if (src === null || src === undefined || (this.image !== null && src === this.image.src)) {
          return
        }
        this.loaded = false
        const self = this
        self.image = new Image()
        self.image.onload = function() {
          self.loaded = true
        }
        self.image.src = src
      })
    },
    now() {
      this.timestamp = new Date().getTime()
    },
    setMode() {
      this.cap = !this.cap
    },
    getMode() {
      if (this.cap) {
        return '摄像头'
      }
      return '屏幕'
    },
    up() {
      if (this.size > 1) {
        this.size = this.size - 1
      }
    },
    down() {
      this.size = this.size + 1
    },
    origin() {
      this.size = 1
    }
  }
}
</script>

