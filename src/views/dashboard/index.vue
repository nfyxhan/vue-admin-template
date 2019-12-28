<template>
  <div class="dashboard-container">
    <div style="height: 95%; width: 95%">
      <img-clicker imagesrc="/static/avatar.png" />
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import ImgClicker from '@/components/Image/click'

export default {
  name: 'Dashboard',
  components: { ImgClicker },
  computed: {
    ...mapGetters([
      'name'
    ])
  }
}
</script>

<style lang="scss" scoped>
.dashboard {
  &-container {
    margin: 30px;
  }
  &-text {
    font-size: 30px;
    line-height: 46px;
  }
}
</style>
