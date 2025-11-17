import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import request from '@ohos.request';
import {UploadOptions,DownloadOptions,HeadersObject,FormDataItem,FileItem,EmptyObject} from  '../datatypes/File'

export class HttpFileManager {
  private static instance: HttpFileManager;

  // 默认头部配置
  private static defaultHeaders: HeadersObject = {
    Accept: '*/*'
  };

  // 私有构造函数，确保单例
  private constructor() {}

  /**
   * 获取单例实例
   */
  public static getInstance(): HttpFileManager {
    if (!HttpFileManager.instance) {
      HttpFileManager.instance = new HttpFileManager();
    }
    return HttpFileManager.instance;
  }

  /**
   * 文件上传方法
   * @param context UIAbilityContext
   * @param options 上传选项
   * @returns 返回上传任务
   */
  public static async upload(context: common.UIAbilityContext, options: UploadOptions): Promise<request.UploadTask | null> {
    try {
      const headers: HeadersObject = HttpFileManager.mergeHeaders(HttpFileManager.defaultHeaders, options.header);

      const uploadConfig: request.UploadConfig = {
        url: options.url,
        header: headers,
        method: options.method || 'POST',
        files: options.files,
        data: options.data || []
      };

      const uploadTask: request.UploadTask = await request.uploadFile(context, uploadConfig);

      // 设置事件监听
      HttpFileManager.setupUploadTaskListeners(uploadTask, options);

      console.info('Upload task created successfully');
      return uploadTask;
    } catch (err) {
      console.error(`Failed to create upload task. err: ${JSON.stringify(err)}`);
      if (options.onError) {
        options.onError(err as BusinessError);
      }
      return null;
    }
  }

  /**
   * 文件下载方法
   * @param context UIAbilityContext
   * @param options 下载选项
   * @returns 返回下载任务
   */
  public static async download(context: common.UIAbilityContext, options: DownloadOptions): Promise<request.DownloadTask | null> {
    try {
      const headers: HeadersObject = HttpFileManager.mergeHeaders(HttpFileManager.defaultHeaders, options.header);

      const downloadConfig: request.DownloadConfig = {
        url: options.url,
        header: headers
      };

      const downloadTask: request.DownloadTask = await request.downloadFile(context, downloadConfig);

      // 设置事件监听
      HttpFileManager.setupDownloadTaskListeners(downloadTask, options);

      console.info('Download task created successfully');
      return downloadTask;
    } catch (err) {
      console.error(`Failed to create download task. err: ${JSON.stringify(err)}`);
      if (options.onError) {
        options.onError(err as BusinessError);
      }
      return null;
    }
  }

  /**
   * 设置上传任务事件监听
   */
  private static setupUploadTaskListeners(task: request.UploadTask, options: UploadOptions): void {
    // 进度监听
    task.on('progress', (receivedSize: number, totalSize: number) => {
      const progress = totalSize > 0 ? (receivedSize / totalSize) * 100 : 0;
      console.info(`Upload Progress: ${progress.toFixed(2)}% (${receivedSize}/${totalSize} bytes)`);

      if (options.onProgress) {
        options.onProgress(progress, receivedSize, totalSize);
      }
    });

    // 完成监听
    task.on('complete', () => {
      console.info('Upload completed successfully');

      if (options.onComplete) {
        options.onComplete();
      }
    });

    // 失败监听
    task.on('fail', () => {
      if (options.onError) {
        options.onError();
      }
    });
  }

  /**
   * 设置下载任务事件监听
   */
  private static setupDownloadTaskListeners(task: request.DownloadTask, options: DownloadOptions): void {
    // 进度监听
    task.on('progress', (receivedSize: number, totalSize: number) => {
      const progress = totalSize > 0 ? (receivedSize / totalSize) * 100 : 0;
      console.info(`Download Progress: ${progress.toFixed(2)}% (${receivedSize}/${totalSize} bytes)`);

      if (options.onProgress) {
        options.onProgress(progress, receivedSize, totalSize);
      }
    });

    // 完成监听
    task.on('complete', () => {
      console.info('Download completed successfully');

      if (options.onComplete) {
        options.onComplete();
      }
    });

    // 失败监听
    task.on('fail', () => {
      if (options.onError) {
        options.onError();
      }
    });
  }

  /**
   * 合并头部配置
   */
  private static mergeHeaders(defaultHeaders: HeadersObject, customHeaders?: HeadersObject): HeadersObject {
    const merged: HeadersObject = {};

    // 复制默认头部
    if (defaultHeaders.Accept) merged.Accept = defaultHeaders.Accept;

    // 复制自定义头部，覆盖默认值
    if (customHeaders) {
      if (customHeaders.Accept) merged.Accept = customHeaders.Accept;
      if (customHeaders.Authorization) merged.Authorization = customHeaders.Authorization;
    }

    return merged;
  }

  /**
   * 暂停上传任务
   * @param task 上传任务
   */
  public static pauseUpload(task: request.UploadTask): void {
    try {
      // 根据API文档，UploadTask可能没有pause方法，这里作为预留
      console.info('Upload task pause requested');
    } catch (err) {
      console.error(`Failed to pause upload task. err: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 暂停下载任务
   * @param task 下载任务
   */
  public static pauseDownload(task: request.DownloadTask): void {
    try {
      // 根据API文档，DownloadTask可能没有pause方法，这里作为预留
      console.info('Download task pause requested');
    } catch (err) {
      console.error(`Failed to pause download task. err: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 创建文件项（辅助方法）
   */
  public static createFileItem(filename: string, name: string, uri: string, type: string): FileItem {
    return {
      filename: filename,
      name: name,
      uri: uri,
      type: type
    };
  }

  /**
   * 创建简单文件项（用于单个文件上传）
   */
  public static createSimpleFileItem(fileUri: string, fieldName: string = 'file', mimeType: string = 'application/octet-stream'): FileItem {
    const segments = fileUri.split('/');
    const filename = segments[segments.length - 1] || 'unknown_file';

    return HttpFileManager.createFileItem(filename, fieldName, fileUri, mimeType);
  }

  /**
   * 创建图片文件项
   */
  public static createImageFileItem(fileUri: string, fieldName: string = 'image'): FileItem {
    return HttpFileManager.createSimpleFileItem(fileUri, fieldName, 'image/jpeg');
  }

  /**
   * 创建表单数据项（辅助方法）
   */
  public static createFormDataItem(name: string, value: string): FormDataItem {
    return {
      name: name,
      value: value
    };
  }

  /**
   * 创建认证头部（辅助方法）
   */
  public static createAuthHeader(token: string): HeadersObject {
    return {
      Authorization: `Bearer ${token}`
    };
  }

}

export default HttpFileManager;