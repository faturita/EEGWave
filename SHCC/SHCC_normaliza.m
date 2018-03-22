function [vn]=normaliza(v)
    minV=min(v);
    maxV=max(v);
    vn = (v-minV)./(maxV-minV);
    