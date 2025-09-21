// 声明接口：描述路由对象的结构
interface RouterConfig {
  LOGIN: string; // 登录页路径
  HOME: string;  // 首页路径
}

// 导出符合接口的路由对象
export const ROUTER: RouterConfig = {
  LOGIN: 'pages/launch',
  HOME: 'pages/home'
};
