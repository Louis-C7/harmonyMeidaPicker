import { Options } from '../utils/Options'
@Component
struct launchCamera {
  @State options: Options = undefined;
  @State callback: void = {} = undefined;

  aboutToAppear() {
    let selectionLimit = this.options.selectionLimit;
    let isSingleSelect = selectionLimit === 1;
    let isPhoto = this.options.mediaType
  }


  build(){}
}