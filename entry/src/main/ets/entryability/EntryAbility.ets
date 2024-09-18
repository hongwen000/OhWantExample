import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import util from '@ohos.util';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    // 在这里处理接收到的 Want
    const imgUri = want.uri;
    console.info(`接收到的图片 URI: ${imgUri}`);

    // 使用 fs 模块打开共享的文件
    try {
      // 打开文件进行读取
      const file = fs.openSync(imgUri, fs.OpenMode.READ_ONLY);
      // 读取文件内容
      const buf = new ArrayBuffer(1024);
      const readLen = fs.readSync(file.fd, buf);
      let decoder = util.TextDecoder.create('utf-8');
      let view: Uint8Array = new Uint8Array(buf); // Use Uint8Array to read data from the object of the ArrayBuffer type.
      let textDecoder: util.TextDecoder = util.TextDecoder.create(); // Call the TextDecoder class of the util module.
      let res: string = textDecoder.decodeWithStream(view); // Decode the view.
      console.info(`读取到的文件内容: ${res}`);
      // 关闭文件
      fs.closeSync(file);
    } catch (err) {
      const error = err as BusinessError;
      console.error(`打开共享文件失败，错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
