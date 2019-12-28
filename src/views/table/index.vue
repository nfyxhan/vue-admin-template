<template>
  <div class="app-container">
    <el-table
      v-loading="listLoading"
      :data="list"
      element-loading-text="Loading"
      border
      fit
      highlight-current-row
    >
      <el-table-column align="center" label="ID" width="95">
        <template slot-scope="scope">
          {{ scope.$index }}
        </template>
      </el-table-column>
      <el-table-column label="Title">
        <template slot-scope="scope">
          {{ scope.row.name }}
        </template>
      </el-table-column>
      <el-table-column label="operate">
        <template slot-scope="scope">
          <a :key="name" href="javascript:" class="blue" @click="openWebSocket(scope.row, 'exec')">连接</a>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import { getPods } from '@/api/pod'

export default {
  filters: {
    statusFilter(status) {
      const statusMap = {
        published: 'success',
        draft: 'gray',
        deleted: 'danger'
      }
      return statusMap[status]
    }
  },
  data() {
    return {
      list: null,
      listLoading: true
    }
  },
  created() {
    this.fetchData()
  },
  methods: {
    fetchData() {
      this.listLoading = true
      getPods().then(response => {
        this.list = response.data.items
        this.listLoading = false
      })
    },
    openWebSocket(row, resource) {
      const url = '/terminal.html?' +
          // 'projectId=' + projectId + '&clusterId=' + clusterId +
          '&namespace=' + 'default' + '&pod=' + row.name + '&container=' + ''// +
      // '&resource=' + resource
      window.open(url)
    }
  }
}
</script>
