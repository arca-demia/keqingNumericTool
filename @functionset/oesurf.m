function oesurf(this)

hull = this.data.hull;

this.graphicHandle.oeplot.fg
hold on
tri = trisurf(hull{:});
hold off

tri.FaceColor = 'interp';
tri.FaceAlpha = 0.5;
tri.EdgeAlpha = 0;

end