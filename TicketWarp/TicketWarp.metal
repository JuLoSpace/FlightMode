//
//  TicketWarp.metal
//  FlightMode
//
//  Created by Ярослав Соловьев on 03.01.2026.
//

#include <metal_stdlib>

using namespace metal;

[[ stitchable ]]
float2 ticketWarp(
                  float2 position,
                  float cutX,
) {
    float2 size = float2(100, 200);
    
    float x = position.x / size.x;
    float y = position.y / size.y;
    
    float curve = 0.0;
    
    if (x < cutX) {
        curve = 0.4 * (position.x - size.x) * cutX * cos(x / cutX * M_PI_2_F);
    }
    
    return float2(position.x, position.y + curve);
}
