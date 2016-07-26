//
// Created by Alexander Evsyuchenya on 7/26/16.
// Copyright (c) 2016 baydet. All rights reserved.
//

import Foundation

protocol OutputStreamDelegate: StreamDelegate {
    func streamHasSpace(stream: OutputStream)
}

class OutputStream: Stream {
    private let outputStream: NSOutputStream
    weak var outputStreamDelegate: OutputStreamDelegate?

    required init(outputStream: NSOutputStream, delegate: OutputStreamDelegate?) {
        self.outputStream = outputStream
        super.init(stream: outputStream, delegate: delegate)
        outputStreamDelegate = delegate
    }

    func writeData(data: NSData) -> Int {
        let value = outputStream.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        return value
    }

    override func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        super.stream(aStream, handleEvent: eventCode)
        if eventCode == NSStreamEvent.HasSpaceAvailable {
            /*delay delegate call. We will not come into racing between HasSpaceAvailable delegate calls because the 2nd
            and later delegate calls will occur only after performing write operation. */
            self.performSelector(#selector(callHasSpace), withObject: nil, afterDelay: drand48())
        }
    }

    @objc private func callHasSpace() {
        self.outputStreamDelegate?.streamHasSpace(self)
    }
}
