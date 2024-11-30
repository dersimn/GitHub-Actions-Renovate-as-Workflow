FROM alpine:3.19.4@sha256:ae65dbf8749a7d4527648ccee1fa3deb6bfcae34cbc30fc67aa45c44dcaa90ee

RUN date > /build-date
CMD ["cat", "/build-date"]
