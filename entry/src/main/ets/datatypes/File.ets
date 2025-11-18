import { BusinessError } from '@kit.BasicServicesKit';

// 基础接口定义
export interface EmptyObject {}

// 头部字段接口
export interface HeadersObject {
  Accept?: string;
  Authorization?: string;
}

// 文件项接口
export interface FileItem {
  filename: string;
  name: string;
  uri: string;
  type: string;
}

// 表单数据项接口
export interface FormDataItem {
  name: string;
  value: string;
}

// 进度回调类型定义
type ProgressCallback = (progress: number) => void;
type CompletionCallback = () => void;
type ErrorCallback = (error?: BusinessError) => void;

// 上传参数接口
export interface UploadOptions {
  url: string;
  files: Array<FileItem>;
  data?: Array<FormDataItem>;
  header?: HeadersObject;
  method?: string;
  onProgress?: ProgressCallback;
  onComplete?: CompletionCallback;
  onError?: ErrorCallback;
}

// 下载参数接口
export interface DownloadOptions {
  url: string;
  header?: HeadersObject;
  filePath?: string;
  onProgress?: ProgressCallback;
  onComplete?: CompletionCallback;
  onError?: ErrorCallback;
}