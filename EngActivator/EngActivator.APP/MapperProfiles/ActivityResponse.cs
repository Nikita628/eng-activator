using AutoMapper;

namespace EngActivator.APP.MapperProfiles
{
    public class ActivityResponseProfile : Profile
    {
        public ActivityResponseProfile()
        {
            CreateMap<DataBase.Entities.ActivityResponse, Dtos.ActivityResponseForDetails>();

            CreateMap<DataBase.Entities.ActivityResponse, Dtos.ActivityResponseForPreview>();

            CreateMap<DataBase.Entities.ActivityResponse, Dtos.ActivityResponseForReview>();

            CreateMap<Dtos.ActivityResponseForCreate, DataBase.Entities.ActivityResponse>();
        }
    }
}
