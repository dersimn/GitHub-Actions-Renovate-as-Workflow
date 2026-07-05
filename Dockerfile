FROM alpine:3.19.4@sha256:7a85bf5dc56c949be827f84f9185161265c58f589bb8b2a6b6bb6d3076c1be21

RUN date > /build-date
CMD ["cat", "/build-date"]
