floodY -= floodSpeed;
if (acidInstance == noone)
{
    acidInstance = instance_create_layer(0, floodY, "Instances", obj_acid_flood);
}
else
{
    if (instance_exists(acidInstance))
    {
        acidInstance.y = floodY;
        acidInstance.image_xscale = room_width / 32;
        acidInstance.image_yscale = (room_height - floodY + 200) / 32;
    }
}
